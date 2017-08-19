$(document).ready ->
  'use strict'

  navActive = null;
  navToggle = ->
    if !navActive
      $('.nav-main, .nav-secondary').css 'left', '0px'
      $('.nav-menu').css
        left: '-80px'
        opacity: '0'
        cursor: 'default'
    else
      $('.nav-main, .nav-secondary').css 'left', ''
      $('.nav-menu').css
        left: ''
        opacity: ''
        cursor: ''
    navActive = !navActive
    return

  setAside = ->
    displayImg = $('#display img')
    i = 0
    while i < displayImg.length
      img = $(displayImg[i])
      img.next('aside').css 'height', img.height()
      img.next('aside').css 'width', img.width()
      i++
    return

  load = ->
    $('body').css 'overflow-y', 'auto'
    $('#loading').css
      'opacity': 0
      'pointer-events': 'none'
    setTimeout (->
      $('#loading').remove()
      return
    ), 500
    setAside()
    return
  
  imagesTotal = $('img').length
  segment = 100 / imagesTotal
  loaded = 0
  before = 0
  after = 0
  $(document).imagesLoaded().progress((instance, image) ->
    animateText = (from, to) ->
      $(current: from).animate { current: to },
        duration: segment / 0.35 * 10
        step: ->
          $('.progress-text p').text @current.toFixed(2)
          return
      return
    if image.isLoaded
      before = loaded
      loaded += segment
      after = loaded
      animateText before, after
      $('#loading .progress-bar').css 'width', loaded + '%'
    else
      $('.failed').append '<p>Fail to load: ' + image.img.src + '</p>'
    return
  ).done ->
    load()
    return

  $(window).resize ->
    setAside()
    return

  $('#display img').hover (->
    $(this).next('aside').css 'opacity', '1'
    $(this).css
      'transform': 'scale(1.01)'
      'filter': 'blur(2px)'
    return
  ), ->
    $(this).next('aside').css 'opacity', ''
    $(this).css
      'transform': ''
      'filter': ''
    return

  $('nav a').click (event) ->
    redirect = ->
      $('body').fadeOut 750, ->
        if pageHash != ''
          window.location = '/' + pageHash
        else
          window.location = pageHref
        return
      return
    event.preventDefault()
    pageHash = @hash
    pageHref = @href
    if pageHash.charAt(0) == '#'
      if window.location.pathname == '/'
        $('html, body').animate { scrollTop: $(pageHash).offset().top }, 800, ->
          window.location.hash = pageHash
          return
      else
        pageHash = @hash
        redirect()
    else
      pageHref = @href
      redirect()
    return

  mainNav = $('.nav-main ul li')
  secNav = $('.nav-secondary ul li span')
  i = 0
  while i < mainNav.length
    $(mainNav[i]).attr 'target', '#nav-span' + i
    $(secNav[i]).attr 'id', 'nav-span' + i
    i++
  $('.nav-main ul li').hover (->
    target = $($(this).attr('target'))
    target.parent().css 'background-color': '#dadad2'
    target.css 'color', '#333333'
    return
  ), ->
    target = $($(this).attr('target'))
    target.parent().css 'background-color': ''
    target.css 'color', ''
    return

  $('.nav-menu, .nav-close').click ->
    navToggle()
    return

  $('.img-loading').hide()

  $('.slide img').click ->
    main = $('#main-img')
    main.attr 'src', $(this).attr('src')
    $('.img-loading').show()
    main.css 'opacity', 0
    main.imagesLoaded().done ->
      main.css 'opacity', 1
      $('.img-loading').hide()
      return
    return
  return

