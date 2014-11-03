---
layout: post
title: YouTube z-index fix
tags: css, youtube, flash, website design
---

Flash appearing behind elements is a common problem with a relatively simple fix — simply add wmode=transparent to the object tag and your Flash movie will behave nicely with the CSS z-index property.

But what happens when you embed a YouTube video?

YouTube’s relatively new embedding code utilizes iFrames — this means that we can’t simply add the wmode tag to the flash object. Here is a little trick to make YouTube include videos that respect z-indexing.

Here is our regular embed code.

{% highlight html %}
<iframe width="420" height="315" src="http://www.youtube.com/embed/C4I84Gy-cPI" frameborder="0" allowfullscreen>
{% endhighlight %}

We can simply add `?wmode=transparent` to the end of YouTube URL. This will tell YouTube to include the video with the wmode set. So you new embed code will look like this;

{% highlight html %}
<iframe width="420" height="315" src="http://www.youtube.com/embed/C4I84Gy-cPI?wmode=transparent" frameborder="0" allowfullscreen>
{% endhighlight %}
