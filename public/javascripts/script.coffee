$(document).ready ->
  'use strict'

  $(window).scroll ->
    if navActive
      navToggle()

  generateInfo = (data) ->
    $('.itemInfoOverlay .title').text data.name
    $('.itemInfoOverlay .date').text data.date
    $('.itemInfoOverlay .desc').text data.description
    $('.itemInfoOverlay .title').text data.title
    if data.showcase == 'true'
      $('.itemInfoOverlay .showcase').removeClass 'disabled'
      $('.itemInfoOverlay .showcase').attr 'href', 'showcases/' + data.itemType + '/' + data._id
    if data.parent 
      $('.itemInfoOverlay .parent').removeClass 'disabled'
    if data.parentTeam 
      $('.itemInfoOverlay .team').removeClass 'disabled'

  setGrid = (callback) ->
    $(".allWorkContainer .row").rowGrid {
      minMargin: 10, 
      maxMargin: 20, 
      itemSelector: '.item',
      resize: true
    }
    typeof callback == 'function' && callback()

  setCurrentView = (view) ->
    if view == 'allWorks'
      $('.vaExt').css {
        top: 0,
        opacity: 1,
        'pointer-events': 'all'
      }
      $('#allWorks').css {
        height: 'initial',
        overflow: 'auto'
      }
      setGrid ->
        $('#selectedWorks').fadeOut()
    else if view == 'selectedWorks'
      $('#selectedWorks').fadeIn()
      $('.vaExt').css {
        top: '',
        opacity: ''
      }
      $('#allWorks').css {
        height: '',
        overflow: ''
      }

  $('.swSelec').click ->
    setCurrentView 'selectedWorks'

  $('.vaSelec').click ->
    setCurrentView 'allWorks'

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
    setGrid()
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

  getData = (type, id) ->
    $.ajax
      url: type + 'data/getData'
      data: 'id': id
      type: 'POST'

  $('.item').click ->
    $('.itemInfoOverlay').addClass 'overlayVisible'
    $('
      .itemInfoOverlay .showcase, 
      .itemInfoOverlay .parent,
      .itemInfoOverlay .team
    ').addClass 'disabled'
    getData($(this).attr('id').split(':')[0], $(this).attr('id').split(':')[1]).then (res) ->
      generateInfo res

  $('.closeOverlay').click ->
    $('.itemInfoOverlay').removeClass 'overlayVisible'

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
