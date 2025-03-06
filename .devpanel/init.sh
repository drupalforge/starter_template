#!/usr/bin/env bash
export PATH="$APP_ROOT/vendor/bin:$PATH"
if [ -n "${DEBUG_SCRIPT:-}" ]; then
  set -x
fi
set -eu -o pipefail
cd $APP_ROOT

LOG_FILE="logs/init-$(date +%F-%T).log"
exec > >(tee $LOG_FILE) 2>&1

TIMEFORMAT=%lR
# Install regardless of security audit.
export COMPOSER_NO_AUDIT=1
export COMPOSER_NO_BLOCKING=1
# Keep deprecated var for compatibility with Composer versions where
# COMPOSER_NO_BLOCKING/--no-blocking is not supported yet.
export COMPOSER_NO_SECURITY_BLOCKING=1
# For faster performance, don't install dev dependencies.
export COMPOSER_NO_DEV=1

#== Remove root-owned files.
echo
echo Remove root-owned files.
time sudo rm -rf lost+found

#== Composer install.
echo
if [ -f composer.json ]; then
  if composer show cweagans/composer-patches ^2 &> /dev/null; then
    echo 'Update patches.lock.json.'
    time composer prl
    echo
  fi
else
  echo 'Generate composer.json.'
  time source .devpanel/composer_setup.sh
  echo
fi
# If update fails, change it to install.
time composer -n update --no-progress

#== Create the private files directory.
if [ ! -d private ]; then
  echo
  echo 'Create the private files directory.'
  time mkdir -m 775 private
else
  sudo chmod 775 -R private
fi

#== Create the config sync directory.
if [ ! -d config/sync ]; then
  echo
  echo 'Create the config sync directory.'
  time mkdir -pm 775 config/sync
else
  sudo chmod 775 -R config
fi

#== Install Drupal.
echo
if [ -z "$(drush status --field=db-status)" ]; then
  echo 'Install Drupal.'
  # Outside DDEV/dev container, fail immediately on the first install error.
  if [ -z "${DRUPALFORGE_DEVCONTAINER:-}" ] && [ "${IS_DDEV_PROJECT:-}" != "true" ]; then
    time drush -n si
  else
    until time drush -n si; do
      :
    done
  fi
else
  echo 'Update database.'
  time drush -n updb
fi

#== Warm up caches.
echo
echo 'Run cron.'
time drush cron
echo
echo 'Populate caches.'
time drush cache:warm &> /dev/null || :
time .devpanel/warm
time .devpanel/warm /user/login

#== Fix ownership for strict permissions.
echo
echo 'Fix ownership for strict permissions.'
time sudo chmod 775 -R web/sites/default/files
time sudo chown -R ${APACHE_RUN_USER:=www-data} web/sites/default/files private config/sync

#== Finish measuring script time.
INIT_DURATION=$SECONDS
INIT_HOURS=$(($INIT_DURATION / 3600))
INIT_MINUTES=$(($INIT_DURATION % 3600 / 60))
INIT_SECONDS=$(($INIT_DURATION % 60))
printf "\nTotal elapsed time: %d:%02d:%02d\n" $INIT_HOURS $INIT_MINUTES $INIT_SECONDS
