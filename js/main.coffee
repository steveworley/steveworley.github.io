---
---

do ( $ = jQuery) ->

  $ ->

    $('html').niceScroll
      styler: 'fb'

    $('#comments-form').pooleApi
      secret: '21b2304a-d0f7-4a05-9c88-9d8eec19ec8c'

    $('.side-menu-open').on 'click', ->
      $('.side-menu').animate left : '0px', 600, 'easeOutCubic'
      false

    $('#side-menu-close').on 'click', (event) ->
      element = $ '.side-menu'
      element.animate left: "-#{ element.outerWidth() }px", 600, 'easeInCubic'
      false

    $('a[href*=#]:not([href=#])').on 'click', ->
      if location.pathname.replace(/^\//, '') is this.pathname.replace(/^\\/, '') and location.hostname is this.hostname
        target = $ this.hash
        target = if target.length then target else $ "[name=#{this.hash.slice(1)}]"

        if target.length
          $('html, body').animate scrollTop: target.offset().top, 700, 'easeInOutExpo'

        false

    $('[data-spy="scroll"]').each ->
      $spy = $(this).scrollspy 'refresh'

    $('.full-height').each ->
      element = $ this
      element.css height: element.closest('.line').find('.content-wrap').height()

  $(window).load ->
    body = $ '#content-body'

    $('#page-loader').fadeOut 200, ->

    if $('html').hasClass 'safari'
      body.removeClass 'animated'

    body.addClass 'fadeInUp'

    setTimeout ->
      $('.full-height').each ->
        element = $ this
        element.css height: element.closest('.line').find('.content-wrap').height()
      false
    , 300

    $(window).resize ->
      $('.full-height').each ->
        element = $ this
        element.css height: element.closest('.line').find('.content-wrap').height()

      false
