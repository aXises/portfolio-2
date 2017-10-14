$(document).ready ->
  'use strict'
  
  getData = (type, id) ->
    $.ajax
      url: type + 'data/getData'
      data: 'id': id
      type: 'POST'
  
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
    $('.itemInfoOverlay .loading').fadeOut()

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
      $('.va').css {
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
        setTimeout ->
          $('#allWorks .loading').fadeOut()
        , 500
    else if view == 'selectedWorks'
      $('#selectedWorks').fadeIn()
      $('.va').css {
        top: '',
        opacity: ''
      }
      $('#allWorks').css {
        height: '',
        overflow: ''
      }

  $('.item').click ->
    $('.itemInfoOverlay .loading').show()
    $('.itemInfoOverlay').addClass 'overlayVisible'
    $('
      .itemInfoOverlay .showcase, 
      .itemInfoOverlay .parent,
      .itemInfoOverlay .team
    ').addClass 'disabled'
    getData($(this).attr('id').split(':')[0], $(this).attr('id').split(':')[1]).then (res) ->
      generateInfo res

  $('.swSelec').click ->
    setCurrentView 'selectedWorks'

  $('.vaSelec').click ->
    setCurrentView 'allWorks'

  $('.teamInfoView').click ->
    $(this).closest('.work').find('.team').css 'top', '0'

  $('.closeOverlay').click ->
    $('.itemInfoOverlay').removeClass 'overlayVisible'