---
layout: post
title: Using a git repo for module dependencies
comments: true
disqus_id: automated-testing-drupal-8
tags:
  - Drupal 8
  - Code management
---

Composer is a great tool for managing code dependencies on a project and most modern PHP frameworks provide excellent integration points and Drupal 8 is no different. You can manage the entire project, create new projects and there is even a Packagist mirror for all Drupal 8 contributed modules so installing a module in D8 is as easy as `composer require drupal/[module]`. I wanted to go through a few things that may not be clear with this new approach to dependency management.

## The composer.json file

{% highlight json %}
{
  "name": "drupal/custom-module",
  "type": "drupal-module",
  "require": {
    "flip/whoops": '^1.0'
  }
}
{% endhighlight %}

Important keys to know when defining a `composer.json` file for a module:

* **name**: Tells composer how to find your package. Drupal has a strict [naming convention](https://www.drupal.org/node/2471927) which states your module should use **drupal/**[YOUR PROJECT NAME]
* **type:** this tells composer what type of package your project is. Most drupal projects should follow the naming guidelines on Drupal.org as these allow you to define custom install paths so you can install modules into the correct directories.
  * **drupal-module**
  * **drupal-custom-module**
  * **drupal-theme**
  * **drupal-custom-theme**
  * **drupal-library**
  * **drupal-profile**
  * **drupal-custom-profile**
  * **drupal-drush**
* **require:** List any dependencies that your module might have

Most Drupal 8 projects should be started with Composer. This allows you to set up a number of variables so future maintenance becomes easier. Your main project `composer.json` file should include at mimumum:

{% highlight json %}
{
  "extra": {
    "installer-paths": {
      "path/to/core": ["type:drupal-core"],
      "path/to/core/modules/contrib/${name}": ["type:drupal-module"],
      "path/to/core/modules/custom/${name}": ["type:drupal-custom-module"],
      "path/to/core/themes/contrib/${name}": ["type:drupal-theme"],
      "path/to/core/themes/custom/${name}": ["type:drupal-custom-theme"],
      "path/to/core/profiles/contrib/${name}": ["type:drupal-profile"],
      "path/to/core/profiles/custom/${name}": ["type:drupal-custom-profile"],
    }
  }
}
{% endhighlight %}

This section of the projects composer file instructres composer where to install packages that meet the "type" filter.

{% highlight json %}
{
    "extra": {
      "merge-plugin": {
        "merge-extra": true,
        "merge-extra-deep": true,
        "replace": false,
        "ignore-duplicates": true
      }
    }
}
{% endhighlight %}

This part provides some specific configuration for the merge plugin. It is recommended that your project includes the merge plugin as this allows sub packages to define composer dependencies and have them install at require time.

## Using Drupal modules

Any drupal module listed on [drupal.org/projects][do] has been made available to Composer so long as they have the correct `composer.json` file.

The main benefits for this are; simpler installation and upgrade paths, module version pinning and module maintenance via `composer.json`. Gone are the days of a custom application to parse a D7 site and find which modules are installed and what versions they're running.

## Using repositories

Composer allows you to install modules directly from tarballs or repositories as well. This can be very helpful in an organisation where you want to break custom functionality into streams and have particular product owners.

As long as your module has a valid `composer.json` file.

## Merge plugin

When you require the Drupal module, the merge plugin will squash the modules `composer.json` file into your projects `composer.json` file and will install all the dependencies listed. This allows Drupal modules to list other Composer packages as dependencies.

## Patches via Composer.json

Module patching can also be done via the `composer.json` file. If you need to fix a bug or apply a module patch before a release is cut you can specific a path (or URL) to the patch file and the next time the project is built composer will attempt to apply the patches to the projects list.

{% highlight json %}
{
  "extra": {
    "patches": {
      "drupal/core": {
        "Issue description": "http://mywebaccessible.patch/path",
        "Issue description": "./path/to/local/patch"
      }
    }
  }
}
{% endhighlight %}


## Putting it all together

There is an interesting byproduct when using the merge plugin and the patches plugin together. It allows your installed dependencies to patch other projects. For example if your profile requires a few core patches, you can specify them in the profile rather than the project that way any project using your profile can benefit.

[repo]: https://github.com/steveworley/whoops
[do]: http://drupal.org
