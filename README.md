<h1>
    <a href="https://www.drupalforge.org/">
        <img src="drupalforge.svg" alt="Drupal Forge" height="100px" />
    </a>
</h1>

This repository is a template for a [Drupal Forge](https://www.drupalforge.org)
app that creates a project with Composer, then installs Drupal with a default
admin password of _admin_. This repository creates
[drupal/recommended-project](https://www.drupal.org/docs/develop/using-composer/starting-a-site-using-drupal-composer-project-templates#s-drupalrecommended-project)
by default.
- To create a different project, change the value of the PROJECT variable in
  [.devpanel/composer_setup.sh](.devpanel/composer_setup.sh#L10).
- To skip creating a project with Composer, add your own composer.json to the
  repository root.

This repository is optimized for fast deployment with
[DevPanel](https://www.devpanel.com). DevPanel deployment files are in the
[`.devpanel`](.devpanel) directory. This repository is also configured to run
locally using [DDEV](https://ddev.com).

For even faster deployment, go to the [Actions](../../actions) tab in GitHub
after you create a new repository from this template and add the _Drupal Forge
Docker Publish Workflow_. This workflow generates a new Docker image whenever a
commit is pushed to the `main`, `develop`, or `test/*` branches. Drupal will be
fully deployed in the Docker image, reducing the time required to launch the
site.
