---
layout: post
title: Drupal Performance Admin Menu
tags: Drupal performance
---

Admin Menu is a great module! It allows your to provide quick and easy navigation to the most used parts of your Drupal administration experience. It provides cache clearing and searching and an array of other nice to haves that don't ship with the default Drupal administration menu. However due to the way that the menu needs to be kept up-to-date this module does not scale very well and can be a prime contributor to slow cache rebuilds and memory issues for larger Drupal sites.

## The Problem

Recently we have been noticing that one of our largest Drupal sites was slowing down and cache rebuilds were taking upwards of 45 seconds- this was causing fatal errors and slowing down development for new features for the site. After delving deep into XHProf reports and reviewing things from feature rebuilds, the culprit ended up being `admin_menu` and it was taking upwards of 25 seconds to rebuild its cache.

It appears that the issue is related to the aggressive cache clearing nature of the `admin_menu` compounded by the number of links that the menu contains. Given more menus to render the rebuilding process takes exponentially more time to render.

The main cause is clearing the `cache_clear_all(isset($uid) ? $cid : '*', 'cache_admin_menu', TRUE);` call that is on line `806`. This is implemented in `hook_flush_caches` so it will be called every cache clear, however the cache clear hook is also called any time the menu is acted on further complicating the issue. The cache is cleared regularly to ensure that the menu is kept up-to-date.

## The solution

One solution we came up with was having the clearing and rebuilding of the menu cache handled by a cron task. This way it could be done behind the scenes and would not impact on the sites overall performance too much, you can also control how frequently the menu gets rebuilt (and even trigger manual clears with drush or the menu itself).

*To start*
- Remove line #806 from `hook_flush_caches` in `admin_menu.module`
- Add a `hook_cron` implementation that looks like:

{% highlight php %}
function admin_menu_flush_caches($uid = NULL) {
  # ... snip.

  if (db_table_exists('cache_admin_menu')) {
    // cache_clear_all(isset($uid) ? $cid : '*', 'cache_admin_menu', TRUE);
  }
}
{% endhighlight %}

{% highlight php %}
function admin_menu_cron() {
  global $user;
  global $base_url;

  $cid = 'admin_menu:';
  if (isset($user->uid)) {
    $cid .= $user->uid;
  }

  // Clear the cache for the admin menu.
  cache_clear_all(isset($user->uid) ? $cid : '*', 'cache_admin_menu', TRUE);

  // A HTTP request will rebuild the menu.
  drupal_http_request($base_url);
}
{% endhighlight %}

The point of this is to move the menu rebuild away from a page visit and have it run at the system level.

## Testing!

To make sure the change is working as expected you will need to ensure that all caches are cleared - so Drupal can pick up the new hook implementation and then run cron. If you have `Drush` otherwise you will need to use the UI to trigger a cache clear and a cron run. For testing (if you're using Drush) you can add a `drush_log` call in `hook_cron` to see it output to your console.

```
$ > drush cc all
$ > drush cron
```
