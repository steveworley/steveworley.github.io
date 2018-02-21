---
layout: post
title: CSS Keylogging and how to protect yourself
comments: true
disqus_id: css-keylogging-security
lead: "A good reason to employ CSPs to protect your customers"
tags:
  - CSS
  - Security
  - CSP
  - Decoupled
---

I recently come across an interesting [git repository](https://github.com/maxchehab/CSS-Keylogging) that demonstrates how CSS can be used as an attack vector for logging unsuspecting users passowrds. This is pretty scary as there are a number of different ways that CSS can be included on a page without you even knowing.

A little while ago I did a post on setting up a [Content Security Policy](http://steveworley.github.io/2017/03/27/csp-drupal-8.html) (CSP); a quick recap - this is a browser directive that limits domain names that can be requested. The CSP acts as a whitelist, blocking all requests to domains that don't appear in your CSP and is a sure fire way to prevent the above CSS Exploit for visitors to your website.

Let's analyse what is happening in the example and understand why a CSP prevents it. The repository suggests that this is primarily an issue with controlled component frameworks (such as React), this is because in order to update the UI a React component needs to manually set the value of an input element that is on the page. If we use the example of Instagram we can see that `value="asdf"` directly in the DOM and it changes based on our input.

![React components](/img/login-value-update.png)

The attack uses CSS3 pseudo selectors which allow us to target particular attributes; for example the `value` attribute. So the attacker simply includes a stylesheet that has a series of `input[type="password][value="a"]` style definitions that update the background image of the element to a remote destination; in the example `http://localhost:3000/a`. With some smarts on the logging server you could piece the requests back together and find a password.

## How do we prevent this?

Well to put it simply, we can't prevent a browser extension from including styles into our page. But we can prevent the browser extension from requesting images. The default browser behaviour will allow all remote assets so we need to deliver a stricter CSP with our repsonse to ensure that we control which resources the browser has access to. Background images in CSS rely on the `img-src` directive in the CSP.

![CSP Blocking](/img/csp-blocking.png)

```
Content-Security-Policy: default 'none' img-src 'self'
```

## Will this protect 100%?

Using a CSP will prevent remote access to images and will mitigate this type of attack. However there are other ways for browser extensions to make external requests. An extension typically runs in two states - background and page. The CSP is only applied to the page level actions of the extension. Using the example repository; this is how the stylesheet is sent to the page regardless of your CSP- the browser will inject the stylesheet regardless, once it has everything in the stylesheet will fall under the page scope and will be affected by your CSP. In the spirit of full disclosure there are still workarounds for the nefarious extensions, [this medium post outlines](https://medium.com/kifi-engineering/dont-let-a-content-security-policy-your-extension-s-images-e062d6b88eac) one way of getting around the CSP using the background scope to build a `base64encoded` image.

While this doesn't fully prevent browser extensions; it can help protect your developers. With the growing ecosystem of frontend packages there is an ever increasing chance that a particular package might be doing something it shouldn't be. This will help ensure that your code base is protected.

In conclusion- a CSP will help mitigate odd behaviour from user devices; while it is not infalible it definitely makes sense to maintain one for your web pressence so you can help to ensure the safety of your visitors.

## Further reading

- [https://github.com/maxchehab/CSS-Keylogging](https://github.com/maxchehab/CSS-Keylogging)
- [https://medium.com/kifi-engineering/dont-let-a-content-security-policy-your-extension-s-images-e062d6b88eac](https://medium.com/kifi-engineering/dont-let-a-content-security-policy-your-extension-s-images-e062d6b88eac)
- [https://content-security-policy.com/](https://content-security-policy.com/)