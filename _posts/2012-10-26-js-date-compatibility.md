---
layout: post
title: Javascript date compatibility
disqus_id: javascript-date
comments: true
tags:
  - Javascript
  - date
---

Every browser implements Javascript in their own way. One of the most notable differences lies in each browsers implementation of the `Date` object. A `date` object can be instantiated with a parameter which is a date, however the formats in which each browser can create the object is quite different.

{:.table .table-stripped .table-demo}
|   | ![Chrome](/img/chrome.png) | ![Firefox](/img/firefox.png) | ![Safari](/img/safari.png) | ![IE7](/img/ie.png) | ![IE8](/img/ie.png) | ![IE9](/img/ie.png) |
|---|---|---|---|---|---|---|
| 11-30-2012 | <i class="fa fa-check primary"></i> | <i class="fa fa-times error"></i> | <i class="fa fa-times error"></i> | <i class="fa fa-check primary"></i> | <i class="fa fa-check primary"></i> | <i class="fa fa-check primary"></i> |
| 30-11-2012 | <i class="fa fa-times error"></i> | <i class="fa fa-times error"></i> | <i class="fa fa-times error"></i> | <i class="fa fa-check primary"></i> | <i class="fa fa-check primary"></i> | <i class="fa fa-check primary"></i> |
| 30/11/2012 | <i class="fa fa-times error"></i> | <i class="fa fa-check primary"></i> | <i class="fa fa-check primary"></i> | <i class="fa fa-check primary"></i> | <i class="fa fa-check primary"></i> | <i class="fa fa-check primary"></i> |
| 11/30/2012 | <i class="fa fa-check primary"></i> | <i class="fa fa-check primary"></i> | <i class="fa fa-check primary"></i> | <i class="fa fa-check primary"></i> | <i class="fa fa-check primary"></i> | <i class="fa fa-check primary"></i> |
| Fri 30 November 2012  | <i class="fa fa-check primary"></i> | <i class="fa fa-check primary"></i> | <i class="fa fa-check primary"></i> | <i class="fa fa-check primary"></i> | <i class="fa fa-check primary"></i> | <i class="fa fa-check primary"></i> |
| 30 Nov 2012 | <i class="fa fa-check primary"></i> | <i class="fa fa-check primary"></i> | <i class="fa fa-check primary"></i> | <i class="fa fa-check primary"></i> | <i class="fa fa-check primary"></i> | <i class="fa fa-check primary"></i> |
| Fri 30 November 2012 12:00 | <i class="fa fa-check primary"></i> | <i class="fa fa-check primary"></i> | <i class="fa fa-check primary"></i> | <i class="fa fa-check primary"></i> | <i class="fa fa-check primary"></i> | <i class="fa fa-check primary"></i> |
| Fri 30 November 2012 12:00:00 | <i class="fa fa-check primary"></i> | <i class="fa fa-check primary"></i> | <i class="fa fa-check primary"></i> | <i class="fa fa-check primary"></i> | <i class="fa fa-check primary"></i> | <i class="fa fa-check primary"></i> |
| Friday 30 Nov 2012 12 | <i class="fa fa-check primary"></i> | <i class="fa fa-times error"></i> | <i class="fa fa-times error"></i> | <i class="fa fa-times error"></i> | <i class="fa fa-times error"></i> | <i class="fa fa-times error"></i> |
| Fri 30 Nov 2012 | <i class="fa fa-check primary"></i> | <i class="fa fa-check primary"></i> | <i class="fa fa-check primary"></i> | <i class="fa fa-check primary"></i> | <i class="fa fa-check primary"></i> | <i class="fa fa-check primary"></i> |
| Friday 30 Nov | <i class="fa fa-check primary"></i> | <i class="fa fa-times error"></i> | <i class="fa fa-times error"></i> | <i class="fa fa-times error"></i> | <i class="fa fa-times error"></i> | <i class="fa fa-times error"></i> |
| Fri 30 Nov | <i class="fa fa-check primary"></i> | <i class="fa fa-times error"></i> | <i class="fa fa-times error"></i> | <i class="fa fa-times error"></i> | <i class="fa fa-times error"></i> | <i class="fa fa-times error"></i> |
| Friday 30 Nov 2012 | <i class="fa fa-check primary"></i> | <i class="fa fa-times error"></i> | <i class="fa fa-check primary"></i> | <i class="fa fa-check primary"></i> | <i class="fa fa-check primary"></i> | <i class="fa fa-check primary"></i> |
| Fri 30 Nov 12:00:00 | <i class="fa fa-check primary"></i> | <i class="fa fa-times error"></i> | <i class="fa fa-check primary"></i> | <i class="fa fa-times error"></i> | <i class="fa fa-times error"></i> | <i class="fa fa-times error"></i> |
| Fri 30 Nov 12:00 | <i class="fa fa-check primary"></i> | <i class="fa fa-times error"></i> | <i class="fa fa-check primary"></i> | <i class="fa fa-times error"></i> | <i class="fa fa-times error"></i> | <i class="fa fa-times error"></i> |
| 11-30-2012 12:00:00 | <i class="fa fa-check primary"></i> | <i class="fa fa-times error"></i> | <i class="fa fa-times error"></i> | <i class="fa fa-check primary"></i> | <i class="fa fa-check primary"></i> | <i class="fa fa-check primary"></i> |
| 30-11-2012 12:00:00 | <i class="fa fa-times error"></i> | <i class="fa fa-times error"></i> | <i class="fa fa-times error"></i> | <i class="fa fa-check primary"></i> | <i class="fa fa-check primary"></i> | <i class="fa fa-check primary"></i> |
| 30/11/2012 12:00:00 | <i class="fa fa-times error"></i> | <i class="fa fa-check primary"></i> | <i class="fa fa-times error"></i> | <i class="fa fa-check primary"></i> | <i class="fa fa-check primary"></i> | <i class="fa fa-check primary"></i> |
| 11/30/2012 12:00:00 | <i class="fa fa-check primary"></i> | <i class="fa fa-check primary"></i> | <i class="fa fa-check primary"></i> | <i class="fa fa-check primary"></i> | <i class="fa fa-check primary"></i> | <i class="fa fa-check primary"></i> |
| 1354298400 | <i class="fa fa-times error"></i> | <i class="fa fa-times error"></i> | <i class="fa fa-times error"></i> | <i class="fa fa-times error"></i> | <i class="fa fa-times error"></i> | <i class="fa fa-times error"></i> |

The table shows values that can be passed to the date object like:

{% highlight js %}
var myDate = New Date('11/30/2012');
{% endhighlight %}
