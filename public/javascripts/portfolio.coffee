$(document).ready ->
  'use strict'
  
  getData = (type, id) ->
    $.ajax
      url: type + 'data/getData'
      data: 'id': id
      type: 'POST'
  
  generateInfo = (data) ->
    $('.itemInfoOverlay .main .title').text data.name
    $('.itemInfoOverlay .main .date').text data.date
    $('.itemInfoOverlay .main .desc').text data.description
    $('.itemInfoOverlay .main .title').text data.title
    $('.info .proj .name').text data.name
    $('.info .proj .type').text data.type
    $('.info .proj .status').text data.status
    $('.info .proj .client').text data.for
    if data.link
      $('.info .proj .link').text data.link
    else
      $('.info .proj .link').text 'Unavaliable'
    if $.isArray data.technologies
      $('.info .proj .technologies').text data.technologies.join(', ')
    else
      $('.info .proj .technologies').text data.technologies
    if data.parentTeam
      getData('team', data.parentTeam).then (res) ->
    if data.showcase == 'true'
      $('.itemInfoOverlay .showcase').removeClass 'disabled'
      $('.itemInfoOverlay .showcase').attr 'href', 'showcases/' + data.itemType + '/' + data._id
    if data.parentCollection
      $('.itemInfoOverlay .parent').attr 'target', data.parentCollection
    $('.itemInfoOverlay .loading').fadeOut()

  setGrid = (selec, callback) ->
    $(".allWorkContainer .row").rowGrid {
      minMargin: 5
      maxMargin: 10
      itemSelector: selec
    }
    typeof callback == 'function' && callback()

  setCurrentView = (view) ->
    $('#allWorks .loading').show()
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
      setGrid '.post', ->
        $('#selectedWorks').fadeOut 500, ->
          $(window).scrollTop(0)
        $('#allWorks .loading').fadeOut()

    else if view == 'selectedWorks'
      $('#allWorks .loading').fadeOut()
      $('#selectedWorks').fadeIn()
      $('.va').css {
        top: '',
        opacity: ''
      }
      $('#allWorks').css {
        height: '',
        overflow: ''
      }
      if $('.itemInfoOverlay').hasClass 'overlayVisible'
        $('.itemInfoOverlay').removeClass 'overlayVisible'

  $('.stat').click ->
    $(this).closest('.work').find('.info.proj').toggleClass 'showLay'
    $(this).closest('.head').find('.shift').toggleClass 'left'

  $('.anchor').click ->
    setCurrentView 'selectedWorks'

  $('.selecItem').click ->
    $('.collection').fadeOut 500, ->
      setGrid '.item'

  $('.selecCol').click ->
    $('.item').fadeOut 500, ->
      setGrid '.collection'

  $('.post').click ->
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
    $(this).closest('.work').find('.team').toggleClass 'showLay'

  $('.info.team .close').click ->
    $(this).parent().toggleClass 'showLay'

  $('.closeOverlay').click ->
    $('.itemInfoOverlay').removeClass 'overlayVisible'