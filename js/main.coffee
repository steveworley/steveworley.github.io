---
---

do ( $ = jQuery) ->

  $ ->

    $('html').niceScroll
      styler: 'fb'


    $('.side-menu-open').click ->
      $('.side-menu').animate left : '0px', 600, 'easeOutCubic'
      false

    $('#side-menu-close').click (event) ->
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
      $('.full-height').each (i, el) ->
        element = $ this
        element.css height: element.closest('.line').find('.content-wrap').height()

      false
