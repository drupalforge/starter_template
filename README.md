<h1>
    <a href="https://www.drupalforge.org/">
        <img src="drupalforge.svg" alt="Drupal Forge" height="100px" />
    </a>
</h1>

This repository is a template for a Drupal Forge app that creates a project
with Composer, then performs a clean Drupal install with a default admin
password of _admin_. It is designed to be a wrapper for a Composer project
developed separately. __If you want to create a template from an existing
Drupal Forge app, you do not need to start with this template.__

This repository creates the Composer project specified by the `PROJECT`
environment variable. If `PROJECT` is not defined, it defaults to
[drupal/recommended-project](https://www.drupal.org/docs/develop/using-composer/starting-a-site-using-drupal-composer-project-templates#s-drupalrecommended-project).
- You can set a different default value for `PROJECT` in
  [.devpanel/composer_setup.sh](.devpanel/composer_setup.sh#L10).
- To skip creating a project with Composer, add your own `composer.json` to the
  repository root.
- You can add the `.devpanel` directory from this repository to an existing
  repository.

This repository is optimized for fast deployment with
[DevPanel](https://www.devpanel.com). DevPanel deployment files are in the
[`.devpanel`](.devpanel) directory. This repository is also configured to run
locally using [DDEV](https://ddev.com).

For even faster deployment, go to the [Actions](../../actions) tab in GitHub
after you create a new repository from this template and add the _Drupal Forge
Docker Publish Workflow_. This workflow generates a new Docker image whenever a
commit is pushed to the `main` or `test/*` branches. Drupal will be
pre-deployed in the Docker image, reducing the time required to launch the
site. If your repository is in the Drupal Forge
[GitHub organization](https://github.com/drupalforge), your image will be in
the Drupal Forge [Docker Hub account](https://hub.docker.com/u/drupalforge).
