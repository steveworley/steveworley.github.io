---
layout: post
title: Disqus with Github pages
comments: true
disqus_id: automated-testing-drupal-8
tags:
  - Github Pages
  - CSP
  - Disqus
---

Today I thought it would be a good idea to add [Disqus](https://disqus.com) comments to the blog, I had always been meaning to do it but never really found the time. So, I fired up Atom and began adding Disqus. Turns out it wasn't as easy as I thought it would be.

It turns out the friendly folks at Github have added a CSP ([Content Security Policy](https://content-security-policy.com/)) to all the pages websites. This is great for security- not so great if you want to include third-party scripts on your site.

Looking around for a solution I found out that you can control the CSP with a `http-equiv` meta tag- up until now I had always assumed that the CSP was sent a response header.

{% highlight html %}}
<meta http-equiv="Content-Security-Policy" content="">
{% endhighlight %}

Add the tag and define you CSP and you can then include cross-domain scripts. The next challenge was finding all the required domains to allow for including disqus. There didn't seem to be any good documentation around about what domains you needed to allow in your CSP.

Here are the domains that I found to allow the comments:

- script-src
  - 'unsafe-inline'
    - _comment-id_.disus.com/embed.js
    - https://a.discuscdn.com
    - https://disqus.com
- style-src
  - 'unsafe-inline'
    - https://a.discuscdn.com
