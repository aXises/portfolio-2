$(document).ready ->
  'use strict'
  
  getData = (type, id) ->
    $.ajax
      url: type + 'data/getData'
      data: 'id': id
      type: 'POST'

  getChildren = (type, id) ->
    $.ajax
      url: type + 'data/getChildren'
      data: 'id': id
      type: 'POST'

  initOverlay = ->
    $('.itemInfoOverlay .loading').show()
    $('.itemInfoOverlay').addClass 'overlayVisible'
    $('.itemInfoOverlay .buttonContainer .showcase, .itemInfoOverlay .buttonContainer .parent').addClass 'disabled'
    $('.itemInfoOverlay .buttonContainer .showcase').attr 'href', ''
    $('.itemInfoOverlay .buttonContainer .parent').attr 'target', ''
  
  generateInfo = (data) ->
    $('.itemInfoOverlay .info .proj, 
       .itemInfoOverlay .info .team,
       .itemInfoOverlay .info .child
    ').append $('.itemInfoOverlay .loading').clone().removeClass 'main'
    $('.itemInfoOverlay .temp').remove()
    $('.itemInfoOverlay .info .title, .itemInfoOverlay .info .value').show()
    if data.itemType == 'item' && data.parentCollection
      getData('collection', data.parentCollection).then (res) ->
        $('.itemInfoOverlay .buttonContainer .parent').removeClass('disabled').attr('target', res._id)
        $('.itemInfoOverlay .col-lg-9 .main').prepend $('<p class="temp"><i>Part of Collection - ' + res.name + '</i></p>')
        $('.itemInfoOverlay .loading.main').fadeOut()
    else
      $('.itemInfoOverlay .loading.main').fadeOut()
    projInfo = (callback) ->
      $('.itemInfoOverlay .main .title').text data.name
      $('.itemInfoOverlay .main .date').text data.date
      $('.itemInfoOverlay .main .desc').text data.description
      $('.itemInfoOverlay .main .title').text data.title
      $('.info .proj .name').text data.name
      $('.info .proj .type').text data.type
      $('.info .proj .status').text data.status
      $('.info .proj .client').text data.for
      if data.link then $('.info .proj .link').text data.link else $('.info .proj .link').text 'Unavaliable'
      if $.isArray data.technologies then $('.info .proj .technologies').text data.technologies.join(', ') else $('.info .proj .technologies').text data.technologies
      callback()
    teamInfo = (callback) ->
      if data.parentTeam
        getData('team', data.parentTeam).then (res) ->
          team = res
          $('.info .team .name').text team.name
          $('.info .team .status').text team.status
          if team.link then $('.info .team .link').text team.link else $('.info .team .link').text 'Unavaliable'
          callback()
      else
        $('.info .team').append $('<p class="temp">Unavaliable</p>')
        $('.info .team .title, .info .team .value').hide()
        callback()
    childInfo = (callback) ->
      if data.itemType == 'collection'
        getChildren('item', data._id).then (res) ->
          for child in res
            $('.info .child').append $('<p class="temp">' + child.name + '</p>')
          callback()
      else
        $('.info .child').append $('<p class="temp">Unavaliable</p>')
        callback()
    projInfo ->
      $('.itemInfoOverlay .info .proj .loading').fadeOut 500, ->
        $(this).remove()
    teamInfo ->
      $('.itemInfoOverlay .info .team .loading').fadeOut 500, ->
        $(this).remove()
    childInfo ->
      $('.itemInfoOverlay .info .child .loading').fadeOut 500, ->
        $(this).remove()
    if data.showcase == 'true'
      $('.itemInfoOverlay .buttonContainer .showcase').removeClass('disabled').attr 'href', 'showcases/' + data.itemType + '/' + data._id

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

  $('.itemInfoOverlay .buttonContainer .parent').click ->
    targetId = $(this).attr('target')
    $('.itemInfoOverlay').removeClass('overlayVisible')
    setTimeout ->
      initOverlay()
      getData('collection', targetId).then (res) ->
        generateInfo res
    , 200

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
    initOverlay()
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