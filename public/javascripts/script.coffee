$(document).ready ->
  'use strict'

  prepAnimations = ->
    $('body').addClass 'no-transitions'
    $('#globalnav').css 'width', '0%'
    $('#index .corners').css 
      'opacity': 0
      'left': '-150px'
    $('#index .text-container h6').css 
      'opacity': 0
      'letter-spacing': '30px'
    return
  prepAnimations()

  navActive = null;

  navToggle = ->
    $('#globalnav .navtoggle .default, #globalnav .navtoggle .back').toggleClass 'disable'
    if !navActive
      $('#globalnav').css 'width', '100%'
      $('#globalnav .navtoggle .default').css 'left', '-50px'
      $('#globalnav .navtoggle .back').css 'left', '0px'
      $('#globalnav .buttonContainer').fadeIn();
    else
      $('#globalnav').css 'width', '0%'
      $('#globalnav .navtoggle .default').css 'left', ''
      $('#globalnav .navtoggle .back').css 'left', ''
      $('#globalnav .buttonContainer').fadeOut();
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
    $('body').removeClass 'no-transitions'
    $('body').css 'overflow-y', 'auto'
    $('#loader').css
      'opacity': 0
      'pointer-events': 'none'
    setTimeout (->
      $('#loader').remove()
      $('#index .corners').css 
        'opacity': ''
        'left': ''
      setTimeout (->
        $('#index .text-container h6').css 
          'opacity': 1
          'letter-spacing': ''
      ), 750
      return
    ), 750
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
      $('#loader .progress-bar').css 'width', loaded + '%'
    else
      $('.failed').append '<p>Fail to load: ' + image.img.src + '</p>'
    return
  ).done ->
    load()
    return

  $(window).resize ->
    setAside()
    return

  $('nav a').click (event) ->
    return

  $('.navtoggle').click ->
    navToggle()
    return

  $('.slide img').click ->
    main = $('#main-img')
    main.attr 'src', $(this).attr('src')
    $('.img-loader').show()
    main.css 'opacity', 0
    main.imagesLoaded().done ->
      main.css 'opacity', 1
      $('.img-loader').hide()
      return
    return
  return

