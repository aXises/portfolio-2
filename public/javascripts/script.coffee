$(document).ready ->
  'use strict'

  $(window).scroll ->
    if navActive
      navToggle()

  $('.elem-container a').hover ->
    $(this).css 'border-color', '#00bdce'
  , ->
    $(this).css 'border-color', ''

  $('#globalnav a').hover ->
    $('#globalnav .followBar').css {
      opacity: 1,
      width: $(this).width(),
      left: $('#globalnav .buttonContainer').position().left + $(this).position().left + 10 +'px'
    }
    if $(this).hasClass('ext')
      $('#globalnav .followBar').css 'background-color', '#00bdce'
      $('#globalnav .divider').css 'border-left', '4px solid #00bdce'
    else 
      $('#globalnav .divider').css 'border-left', ''
  , ->
    $('#globalnav .followBar').css {
      'background-color': '',
      width: 0,
      left: $('#globalnav .buttonContainer').position().left + $(this).position().left + 10 + 'px'
    }

  prepAnimations = ->
    $('body').addClass 'no-transitions'
    $('#index .corners').css 
      'opacity': 0
      'left': '-150px'
    $('#index .text-container h6').css 
      'opacity': 0
      'letter-spacing': '30px'
  prepAnimations()

  navActive = null;

  navToggle = ->
    $('.navtoggle .default,.navtoggle .back').toggleClass 'disable'
    if !navActive
      $('#globalnav').css 'left', '0px'
      $('#globalnav .buttonContainer').fadeIn();
      $('#globalnav a').css 'pointer-events', ''
      $('.navtoggle .default').css 'left', '-50px'
      $('.navtoggle .back').css 'left', '0px'
    else
      $('#globalnav').css 'left', $('#globalnav').width()
      $('#globalnav .buttonContainer').fadeOut();
      $('#globalnav a').css 'pointer-events', 'none'
      $('.navtoggle .default').css 'left', ''
      $('.navtoggle .back').css 'left', ''
    navActive = !navActive
  
  setAside = ->
    displayImg = $('#display img')
    i = 0
    while i < displayImg.length
      img = $(displayImg[i])
      img.next('aside').css 'height', img.height()
      img.next('aside').css 'width', img.width()
      i++

  load = ->
    $('body').removeClass 'no-transitions'
    $('body').css 'overflow-y', 'auto'
    $('#loader').css
      'opacity': 0
      'pointer-events': 'none'
    setTimeout ->
      $('#loader').remove()
      $('#index .corners').css 
        'opacity': ''
        'left': ''
      setTimeout ->
        $('#index .text-container h6').css 
          'opacity': 1
          'letter-spacing': ''
      , 750
      return
    , 750
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
    if image.isLoaded
      before = loaded
      loaded += segment
      after = loaded
      animateText before, after
      $('#loader .progress-bar').css 'width', loaded + '%'
    else
      $('.failed').append '<p>Fail to load: ' + image.img.src + '</p>'
  ).done ->
    setTimeout ->
      load()
    , 1000

  $(window).resize ->
    setAside()
    return

  $('nav a').click (event) ->
    return

  $('.navtoggle').click ->
    navToggle()
    return

  $('.teamInfoView').click ->
    $(this).closest('.work').find('.team').css 'top', '0'

  $('.close').click ->
    $(this).closest('.overlay').attr 'style', ''

  return
