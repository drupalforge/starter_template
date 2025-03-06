#!/usr/bin/env bash
# This file is an example for a template that wraps a Composer project. It
# pulls composer.json from the Drupal recommended project and customizes it.
# You do not need this file if your template provides its own composer.json.

set -eu -o pipefail
cd $APP_ROOT

# Create required composer.json and composer.lock files.
composer create-project --no-install ${PROJECT:=drupal/recommended-project}
rm -f ${PROJECT#*/}/LICENSE* ${PROJECT#*/}/README*
cp -r ${PROJECT#*/}/* ./
rm -rf ${PROJECT#*/}

# Scaffold settings.php.
composer config -jm extra.drupal-scaffold.file-mapping '{
    "[web-root]/sites/default/settings.php": {
        "path": "web/core/assets/scaffold/files/default.settings.php",
        "overwrite": false
    }
}'
composer config scripts.post-drupal-scaffold-cmd \
    'cd web/sites/default && test -z "$(grep '\''include \$devpanel_settings;'\'' settings.php)" && patch -Np1 -r /dev/null < $APP_ROOT/.devpanel/drupal-settings.patch || :'

# Add Drush.
composer require -n --no-update drush/drush
