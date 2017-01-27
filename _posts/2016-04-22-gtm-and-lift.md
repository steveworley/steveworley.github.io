---
layout: post
title: Tracking with Google Tag Manager and Lift
comments: true
disqus_id: tracking-gtm-lift
tags:
  - Acquia Lift
  - Drupal
  - Google Tag Manager
---

In a typical implementation your application would handle creating events for user interactions and would trigger any relevant tracking beacons.

When we integrate with GTM, GTM becomes the source for event delegation. It will send a **Tag** to the page that can interact with the Lift JS API to track a user event. Moving event management to a GTM allows for more flexibility on how events are tracked and can increase time to market for new campaigns.

### Requirements

#### Add the GTM container and Lift Tracker

You need to make sure that the site has both the GTM container and the Lift tracker available.

- [Setting up tag manager](https://support.google.com/tagmanager/answer/6103696?hl=en)
- [Setting up lift](https://docs.acquia.com/lift/offers/tracker/add)

#### Create a custom HTML Tag

A tag is something that Google Tag Manager will execute on your site after a particular set of criteria has been met. Google Tag Manager has a number of preconfigured variables (some that you may need to turn on) out of the box and it also allows you to define custom variables.

The most simple variable is the _Clicks_ variables which will trigger a tag when a particular click event happens. You will need to navigate to the **Variables** page and discover what is enabled for your GTM account.

With GTM you want to create a _Custom HTML Tag_. This will allow you to inject arbitrary code when the visitor triggers the tag.

#### Add the Lift Tracking code

Once the tag has been configured you then need to add the correct Lift event tracking. This works because when the Lift tracker initilises it assigns the `CommandQueue` object to the window scope. Below are some examples of typical events that might be triggered from GTM.

##### **Track an event**

``` html
<script type="text/javascript">
  _tcaq.push(['captureView', '<event name>']);
</script>
```

_note: `<event name>` needs to be a valid event that has been previously created in Lift Web._

- [For more information about the API](https://docs.acquia.com/lift/javascript/view)


##### **Identify a user**

``` html
<script type="text/javascript">
  var name = document.querySelector('.name').value,
      email = document.querySelector('.email').value;

  var id = {};
  // Lift requires an identity object to match:
  // {
  //   "test@email.com": "email"
  //   "<value>": "<type>"
  // }
  id[email] = 'email';
  id[name] = 'name';

  _tcaq.push(['captureIdentity', name, 'name', {}, {identity: id}]);
</script>
```

- [For more information about the API](https://docs.acquia.com/lift/javascript/identity)
