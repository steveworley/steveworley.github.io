---
layout: post
title: Container mocking in PHPUnit tests
comments: true
disqus_id: container-mocking-phpunit-tests
tags:
  - Drupal 8
  - PHPUnit
  - unit testing
---

I've made a few posts recently about getting into PHPUnit testing with Drupal 8. In this post we'll try and delve into a specific section that I found challenging especially when starting writing the unit tests.

Often your business logic will rely on services or properties of the `\Drupal` container object. To help keep unit testing lean Drupal doesn't instantiate a full container object when running unit tests. This means that you might not have access to the necessary data to correctly test your methods.

Let's go through building a more robust container that we can use in our unit tests.

## Our sample

To keep things simple let's say that our business logic requires the current user object.

{% highlight php %}
<?php
class Class {
  public static function exampleMethod() {
    if (\Drupal::currentUser()->getAccountName() === 'sample') {
      return 'yes';
    }
    return 'no';
  }
}
{% endhighlight %}

## The unit test

{% highlight php %}
<?php
class ClassTest extends UnitTestCase {
  public function testExampleMethod() {
    $this->assertEquals('yes', Class::exampleMethod());
  }
}
{% endhighlight %}

This will actually result in an error because our container is not instantiated correctly.

{% highlight %}
$ \Drupal::$container is not initialized yet. \Drupal::setContainer() must be called with a real container.
{% endhighlight %}

## What gives?

The main reason that Drupal doesn't build a full container is to keep the unit testing process running quickly. When PHPUnit finds a test file it creates a new lean testing kernel each time. So you can see that if it built out a full request container each time it would really impact your testing suite.

What this allows us to do is specify exactly which services we need and what values we need to set on the container for our specific unit test case. If we need a particular service we can build the container and add it. If we need the current user we can mock a user object and add it to the container.

But how do we build a container?

- We can use the `ContainerBuilder` object to build a new container
- The Drupal object allows us to override the container
- We can use the PHPUnit fixtures to run these things  

{% highlight php %}
<?php
class ClassTest extends UnitTestCase {
  public function setUp() {
    \Drupal::unsetContainer();
    $container = new ContainerBuilder();
    \Drupal::setContainer($container);
  }
}
{% endhighlight %}

That's it! We set up a container with `ContainerBuilder`. We can no call any of the available methods to build the container to match our test case. In the example we need the `current_user` property from the container, so we should set that!

{% highlight php %}
<?php
class ClassTest extends UnitTestCase {
  public function setUp() {
    \Drupal::unsetContainer();
    $container = new ContainerBuilder();

    $acc = $this->getMockBuilder('Drupal\Core\Session\AccountProxyInterface')
      ->disableOriginalConstructor()
      ->getMock();
    $container->set('current_user', $acc);

    \Drupal::setContainer($container);
  }
}
{% endhighlight %}

If we add the `setUp` fixture that builds our container each test method in our test class will have access to the container!

## A note on fixtures and dataProviders

Now PHPUnit gives us access to another pattern; the `@dataProvider` annotation. This allows us to build a set of reusable data sets to run through our test methods, which is great for lean test cases. Let's have a look at an example.

{% highlight php %}
<?php
class ClassTest extends UnitTestCase {
  public function setUp() {
    \Drupal::unsetContainer();
    $container = new ContainerBuilder();

    $acc = $this->getMockBuilder('Drupal\Core\Session\AccountProxyInterface')
      ->disableOriginalConstructor()
      ->getMock();
    $container->set('current_user', $acc);

    \Drupal::setContainer($container);
  }

  /**
   * @dataProvider testDataProvider
   */
  public function testExampleMethod($user) {
    $this->assertEquals('yes', Class::exampleMethod());
  }

  public function testDataProvider() {
    return [
      [\Drupal::currentUser()]
    ];
  }

}
{% endhighlight %}

Even though we have built the container we will still get the error mentioned above. This is because the PHPUnit internals call the data provider method before it calls the test setup method. To prevent this we can define another method to call when we need to set up the container.

So there you have it a built container with methods that I services can use. You can add anything you'd like to the container using the [methods](https://api.drupal.org/api/drupal/core%21lib%21Drupal%21Core%21DependencyInjection%21ContainerBuilder.php/class/ContainerBuilder/8.2.x). While dependency injection is the way to go where possible, sometimes that's just not an option so this might help in those cases.
