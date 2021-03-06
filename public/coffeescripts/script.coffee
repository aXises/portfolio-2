isFirefox = typeof InstallTrigger != 'undefined'

$(document).ready ->
  'use strict'

  if isFirefox
    $('#loader .elem-container').attr 'style', 'left: calc(50% - 8px) !important'

  $(window).scroll ->
    if navActive
      navToggle()

  toHash = (hash) ->
    $('html, body').animate {
      scrollTop: $(hash).offset().top
    }, 350

  $('a').click (e) ->
    e.preventDefault()
    href = $(this).attr 'href'
    if href.charAt(0) == '#'
        toHash href
    else
      $('body').fadeOut 250, ->
        window.location = href

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

  navActive = false;

  navToggle = ->
    $('.navtoggle .default,.navtoggle .back').toggleClass 'disable'
    if !navActive
      $('#globalnav').css 'left', '0px'
      $('#globalnav .buttonContainer').fadeIn();
      $('#globalnav a').css 'pointer-events', ''
      $('.navtoggle .default').css 'left', '-50px'
      $('.navtoggle .back').css 'left', '0px'
      $('.home').fadeIn()
    else
      $('#globalnav').css 'left', $('#globalnav').width()
      $('#globalnav .buttonContainer').fadeOut();
      $('#globalnav a').css 'pointer-events', 'none'
      $('.navtoggle .default').css 'left', ''
      $('.navtoggle .back').css 'left', ''
      $('.home').fadeOut()
    navActive = !navActive
  
  setAside = ->
    if !navActive
      $('#globalnav').css 'left', $('#globalnav').width()

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
    , 750
    setAside()
  
  imagesTotal = $('img').length
  segment = 100 / imagesTotal
  loaded = 0
  before = 0
  after = 0
  failedImg = 0
  loadedImg = 0
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
      loadedImg++
    else
      failedImg++
      $('.failed').append '<p>Fail to load: ' + image.img.src + '</p>'
    if failedImg > 0 && failedImg + loadedImg == imagesTotal
      $('.failed').append '<p>' + failedImg + ' Image/s failed to load</p>'
      setTimeout ->
        $('.failed').append '<p>Initialising...</p>'
        setTimeout ->
          load()
        , 2000
      , 1000
  ).done ->
    setTimeout ->
      $('.progress-text p').text '100.00'
      load()
    , 1000

  $(window).resize ->
    setAside()

  $('.navtoggle').click ->
    navToggle()

  $('.close').click ->
    $(this).closest('.overlay').attr 'style', ''

