---
layout: post
title: CSS attribute Selectors
disqus_id: css-attribute-selector
comments: true
tags:
  - Attribute Selectors
  - Advanced CSS Selectors
  - CSS
  - Selectors
---

An interesting and somewhat unused feature of CSS is that it allows you to target elements based on the attributes of those elements. You are probably familiar with the more common ones; like type when trying to select different forms of input elements, however you can actually target quite a few other attributes in this way, modern browsers will allow you to select any attribute name however it will only work in `IE7` and `IE8` if a `!DOCTYPE` is specified. You can also use operational selectors (not just equals) similar to jQuery. These operators include:

  - `*= contains`
  - `~= contains word`
  - `^= starts with`
  - `$=ends with`

Unfortunately we cannot do “not equals” (!=) with the attribute selectors in CSS. You can however mix two together to get a pseudo not equals to ie. `[rel="this"][rel="this2"]` and this will only select elements that match both.

I have tried the following in IE7+.

  - `[data-*="val"]`
  - `[rel="val"]`
  - `[title="val"]`
  - `[href="val"]`
  - `[aria-*="val"]`

You can even use custom attribute selectors; like `[myattr="val"]`.

For example lets say we wanted to target an iframe that Google AdWords includes for conversion tracking; unfortunately the iframe does not have a class or an ID — no matter we can select it from its name attribute. Take the given iframe

{% highlight html %}
<iframe name="google_conversion_tracking" src="..."></iframe>
{% endhighlight %}

We can select it in CSS with

{% highlight css %}
iframe[name="google_conversion_tracking"] {
  /* your styles */
}
{% endhighlight %}
