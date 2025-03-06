<h1>
    <a href="https://www.drupalforge.org/">
        <img src="drupalforge.svg" alt="Drupal Forge" height="100px" />
    </a>
</h1>

This is a template for creating a [Drupal Forge](https://www.drupalforge.org)
app that fetches its code with Composer, then installs Drupal with a default
admin password of _admin_. It is optimized for fast deployment with [DevPanel](https://www.devpanel.com).
DevPanel deployment files are in the [`.devpanel`](.devpanel) directory. This
repository is also configured to run locally using [DDEV](https://ddev.com).

For even faster deployment, go to the [Actions](../../actions)
tab in GitHub after you have created your repository and add the _Drupal Forge
Docker Publish Workflow_. This will generate a Docker image whenever a commit is
pushed to the `main`, `develop`, or `test/*` branches. Drupal will be fully deployed
in this Docker image, reducing the time required to launch the site.
