---
layout: post
title: Form element templates in Drupal 8
comments: true
disqus_id: form-element-templates
tags:
  - Drupal 8
  - Templates
  - Twig
---

Many CSS frameworks require nesting your input control elements inside the label tag. Recently I was using [UI Kit](https://github.com/govau/uikit) and it has the requirement for form controls.

{% highlight html %}
<label class="uikit-control-input">
  <input type="checkbox" class="uikit-control-input__input" value="Value">
  <span class="uikit-control-input__text">Value</span>
</label>
{% endhighlight %}

In Drupal 8 there are 3 templates at work when rendering a form element.

- form-element.html.twig
- form-element-label.html.twig
- input.html.twig

Unfortunately the form element templates do not have context of which type of form element is being rendered so you cannot simply add a `form-element-[type]` template file to your theme.

To do this you need to add theme hook suggestions and some additional data to the render array so we have access to all the data we need.

**MYTHEME.theme**

{% highlight php %}

/**
 * Implements hook_theme_suggestions_HOOK_alter().
 */
function MYTHEME_theme_suggestions_form_element_alter(&$suggestions, $variables) {
  array_unshift($suggestions, 'form_element__' . $variables['element']['#type']);
}

/**
 * Implements hook_preprocess_form_element().
 */
function MYTHEME_preprocess_form_element(&$variables) {
  $variables['label']['#__element_type'] = $variables['element']['#type'];
}

/**
 * Implements hook_theme_suggestions_HOOK_alter().
 */
function MYTHEME_theme_suggestions_form_element_label_alter(&$suggestions, $variables) {
  $suggestions[] = 'form_element_label__' . $variables['element']['#__element_type'];
}

{% endhighlight %}

With these hooks implemented we will be able to add templates per form element type. Some valid templates:

- `form-element--checkbox.html.twig`
- `form-element-label--checkbox.html.twig`
- `form-element--radio.html.twig`
