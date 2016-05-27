---
layout: post
title: Javascript loop performance
tags:
  - jQuery
  - $.each
  - do while loop
  - for loop
  - foreach loop
  - javascript
  - looping methods
  - while loop
---

With the wide adoption of jQuery, looping over datasets is easier than ever. I have found that while the different looping functions have different applications each can have a significant impact on your application.

First let's go through the different types of loops that Javascript has on offer.

## for

A `for` loop is generally used for arrays when you have a known number of loop iterations, which is usually found by accessing an arrays length property. A for loop takes 3 parameters;

{% highlight js %}
var array = ['value 1', 'value 2', 'value 3'];
var count = array.length;
for (var i=0; i < count; i++) {
  alert(array[i]);
}
{% endhighlight %}

## for ... in

A `for...in` loop works similarly to a for loop with one major difference, it can be used to loop through properties of an object literal. At the beginning of each iteration the `key` variable is reassigned to the current index (array) or property (object) so you can use the value in a code block.

{% highlight js %}
var array = ['value 1', 'value 2', 'value 3'];
for (var key in array) {
  alert(array[key]);
}

var object = {
  prop1: 'value 1',
  prop2: 'value 2',
  prop3: 'value 3',
}
for (var key in object) {
  alert(object[prop1]);
}
{% endhighlight %}

## while

A while loop works similarly to the for loop however it’s syntax does not allow an initialisation or incremental parameter to be passed - these variables will need to be declared outside of the loops scope. A while loop will evaluate your expression before entering the `code block`. If the expression evaluates `false`, the loop will terminate and will move to next set of instructions.

*Note: While loops do not necessarily need to be used on an array.*

{% highlight js %}
var array = ['value 1', 'value 2', 'value 3'];
var count = array.length;
var i = 0;
while (i < count) {
  alert(array[i]);
  i++;
}
{% endhighlight %}

### do ... while

The `do ... while` loop works exactly like the while loop however the `code block` will always be evaluated once. As with all loop structures it will continue executing the `code block` until the condition evaluates to `false`.

{% highlight js %}
var array = ['value 1', 'value 2', 'value 3'];
var count = array.length;
var i = 0;
do {
  alert(array[i]);
  i++;
}
while (i < count);
{% endhighlight %}

### Array.prototype.forEach()

In the latest release of Javascript (ECMA Script 5), you can now invoke a `forEach` method on your arrays. This will iterate over every member in the array and will call a callback receiving the current iteration as a parameter.

*Note: The callback will be given 3 parameters - the array value, the array index and the array*

{% highlight js %}
var array = ['value 1', 'value 2', 'value 3']
array.forEach(function(value, index, array) {
  alert(value);
});
{% endhighlight %}

### jQuery and $.each();

jQuery provides a function that can be used to iterate over both objects and arrays. `jQuery.each` maintains an index for your array (or object), because the jQuery.each function allows you to loop seamlessly over arrays or objects; this can be a little more resource intensive. If you’re using jQuery.each on a desktop webpage you will not notice too much impact on the speed of your app or webpage; however when you move to mobile devices, the increase in processing can make your page or app unresponsive.

# Performance

Because Javascript is a client-side technology performance will be greatly affected by the speed and performance of the device that is executing it. I have written up some benchmarks that help demonstrate performance considerations by device - you can run the tests on [jsPerfs][perf] to see which looping method works best for your device.

The while method is the best for performance, but only slightly. Most developers will argue that a for loop should be used when iterating through arrays, mainly because of it’s syntax is easier to follow.

![Performance breakdown](/img\blogs\javascript-loops-performance.png)

[perf]: http://jsperf.com/loop-with-code
