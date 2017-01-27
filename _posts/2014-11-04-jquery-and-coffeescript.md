---
layout: post
title: Using jQuery with CoffeeScript
disqus_id: jquery-coffeescript
comments: true
tags:
  - CoffeeScript
  - jQuery
  - Javascript
---

[CoffeeScript][coffee] is a language that compiles into Javascript. It aims to abstract the difficult and awkward parts of Javascript and introduce things that are missing (in the mind of the developer). The syntax that is used by `CoffeeScript` is more concise and eliminates the need for many of the parenthesis and semi-colons that you typically would need to write.

At first I found [CoffeeScript][coffee] a bit clunky, coming from a background of programming that doesn't rely on indentation, but after using it more I began to find it easier and nicer to write.

### Anonymous closures

The Drupal code standard for Javascript is to include your functionality in a closure which is given references to `jQuery`, `Drupal` and `window`.

{% highlight js %}
do ( $ = jQuery, Drupal = Drupal, window = this ) ->
  console.log Drupal
{% endhighlight %}

**Compiled:**

{% highlight js %}
// Vanilla JS
(function($, Drupal, window)) {
	console.log(Drupal);
})(jQuery, Drupal, window);
{% endhighlight %}

### DOM ready

The jQuery DOM ready event can be written like:

{% highlight js %}
$ ->
  element = $ '.selector'
{% endhighlight %}

**Compiled:**

{% highlight js %}
$(function() {
  var element = $('.selector');
})
{% endhighlight %}

### Event binding + selecting elements

Elements can be selected in a few different ways, this is one place in CoffeeScript that you will require `()` (parenthesis).

{% highlight js %}
element = $ '.my-selector'
element.on 'click', ->
  alert 'clicked'
  false

$('.my-selector').on 'click', (evt) ->
  alert 'second click'
  evt.preventDefault()
{% endhighlight %}

**Compiled:**

{% highlight js %}
var element = $('.my-selector');
element.on('click', function() {
  alert('clicked');
  return false;
});

$('.my-selector').on('click', function(evt) {
  alert('second click');
  evt.preventDefault();
});
{% endhighlight %}

### Plugins with parameters

There are two ways you can call member functions of a jQuery element.

{% highlight js %}
element = $ '.my-selector'
element.animate left : '0px', top: '100px', 600, 'easeOutCubic', ->
  alert 'finished animating'

element.animate
  left: '0px'
  top: '100px'
  600
  'easeOutCubic'
  ->
    alert 'finished animating'
{% endhighlight %}

**Compiled:**

{% highlight js %}
var element = $('.my-selector');
element.animate({
  left: '0px',
  top: '100px'
}, 600, 'easeOutCubic', function() {
  return alert('finished animating');
});

element.animate({
  left: '0px',
  top: '100px'
}, 600, 'easeOutCubic', function() {
  return alert('finished animating');
});
{% endhighlight %}

[coffee]: http://coffeescript.org/
