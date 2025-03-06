#!/usr/bin/env bash
set -eu -o pipefail
cd $APP_ROOT

# Create required composer.json and composer.lock files
time composer create-project -n --no-plugins --no-install drupal/recommended-project
cp -r recommended-project/* ./
rm -rf recommended-project patches.lock.json

# Add Drush and Composer Patches.
composer require -n --no-plugins --no-update drush/drush cweagans/composer-patches:^2@beta

# Programmatically fix Composer 2.2 allow-plugins to avoid errors
composer config --no-plugins allow-plugins.composer/installers true
composer config --no-plugins allow-plugins.cweagans/composer-patches true
composer config --no-plugins allow-plugins.drupal/core-project-message true
composer config --no-plugins allow-plugins.drupal/core-vendor-hardening true
composer config --no-plugins allow-plugins.drupal/core-composer-scaffold true
composer config --no-plugins allow-plugins.dealerdirect/phpcodesniffer-composer-installer true
composer config --no-plugins allow-plugins.phpstan/extension-installer true
composer config --no-plugins allow-plugins.mglaman/composer-drupal-lenient true
composer config --no-plugins allow-plugins.php-http/discovery true
composer config --no-plugins allow-plugins.tbachert/spi false

# Scaffold settings.php.
composer config --no-plugins -j extra.drupal-scaffold.file-mapping '{
    "[web-root]/sites/default/settings.php": {
        "path": "web/core/assets/scaffold/files/default.settings.php",
        "overwrite": false
    }
}'
composer config --no-plugins scripts.post-drupal-scaffold-cmd \
    'cd web/sites/default && (patch -Np1 -r /dev/null < "${APP_ROOT}"/.devpanel/drupal-settings.patch | : )'
