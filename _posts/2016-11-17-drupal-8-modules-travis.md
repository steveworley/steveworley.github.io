---
layout: post
title: Automate your Drupal 8 project testing with Travis CI
comments: true
disqus_id: automated-testing-drupal-8
tags:
  - Drupal 8
  - Automated Testing
  - PHP Unit
  - Functional testing
---

Travis CI is a hosted continuous integration service that offers free testing for public github repositories which makes it a great candidate to integrate with your next Drupal project.

I recently set up CI for a [project](https://github.com/steveworley/restrict) I'm maintaining and found that it wasn't as easy as I thought. especially when attempting to use Drupal 8's functional testing framework.

### Setup

Travis CI allows you to commit a configuration file which will describe how your testing environment should be built. We'll run through a sample `.travis.yml` file and see what it's doing.

First you need to define your language and versions.

``` yml
language: php
php:
  - 5.6
  - 7
```

This will tell Travis CI to build 2 environments (5.6 and 7) and perform your tests on both.

Next, you should add [Composer's](http://getcomposer.org) vendor directory to the path so we can use Drush.

``` yml
env:
  - PATH="$HOME/.composer/vendor/bin:$PATH"
```

Travis will create new environments for each line in your environment variable section, this lets you tests a number of configurations. To define multiple environment variables for a single environment you separate them with a space.

Then you define MySQL credentials just defining credentials is enough to tell Travis that it needs to install MySQL.

``` yml
mysql:
  database: drupal
  username: root
  password:
```

Travis provides a number of ways to [customise the build](https://docs.travis-ci.com/user/customizing-the-build) prior to running the tests. As we're going to be using Drush to install Drupal, this is a great place for ensuring it is available.

``` yml
before_install:
  - composer self-update
  - composer global require drush/drush
```

Now we can define the install steps for setting up Drupal.

``` yml
install:
  - cd ..
  - composer create-project drupal-composer/drupal-project:8.x drupal --stability dev --no-interaction
  - mysql -e 'create database drupal;'
```

By using composer to create a new Drupal project we get all the dev dependencies of the project. This is necessary as we need to use the bundled version of PHP Unit and not Travis' version.

After we download Drupal and set up MySQL we need to install Drupal and move our project into the correct directory (`modules` for modules and `themes` for themes). This should still be in the `install` key of your YML file.

``` yml
  - mv [project] drupal/web/[directory]
  - cd drupal/web
  - drush --verbose site-install --db-url=mysql://root:@127.0.0.1/drupal --yes
  - drush en -y [project]
  - drush rs 8080 - &
  - sleep 5
  # Move back to the project root as script will be run from that directory.
  - cd ..
```

When running functional tests we need to have a server available that can handle requests this is why we run `drush rs 8080 -` we sleep the process to ensure the server has enough time to start.

We now have a PHP environment running the latest stable version of Drupal 8 and our project. The last thing we need to do is run the tests.

``` yml
script: SIMPLETEST_BASE_URL=http://127.0.0.1:8080 SIMPLETEST_DB=mysql://root:@127.0.0.1/drupal vendor/bin/phpunit -c web/core/phpunit.xml.dist --group [project]
```

The mink driver for the `BrowserTestBase` class still relies on some `SIMPLETEST_` environment variables. You can specify those prior to running the PHP Unit binary which will override the defaults provided by the configuration file we pass in.

See a full [example](http://gitub.com/steveworley/restrict/blob/master/.travis.yml).

### Gotchas

- Travis lets you run commands like `phpunit` with a pre-installed version this is not compatible with `BrowserTestBase`
- Using an older version of PHP Unit means that the latest documentation is not available
- If you are only running unit tests you don't need to run a server

### Useful resources

This was the first attempt I made a running functional PHPUnit tests on Travis. Here are some articles that I found very helpful in getting this all set up.

- [https://docs.travis-ci.com/](https://docs.travis-ci.com/)
- [https://www.drupal.org/docs/8/phpunit](https://www.drupal.org/docs/8/phpunit) [https://www.chapterthree.com/blog/drupal-8-automated-testing-travis-ci](https://www.chapterthree.com/blog/drupal-8-automated-testing-travis-ci)
- [https://github.com/LionsAd/drupal_ti](https://github.com/LionsAd/drupal_ti)
- [https://www.drupalwatchdog.com/blog/2014/12/test-now-travis-integration-your-drupal-modules](https://www.drupalwatchdog.com/blog/2014/12/test-now-travis-integration-your-drupal-modules)
- [http://blog.freelygive.org.uk/2016/01/15/testing-with-travis-ci-on-github/](http://blog.freelygive.org.uk/2016/01/15/testing-with-travis-ci-on-github/)
