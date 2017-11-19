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

  linkTo = (type, id) ->
    if $('.itemInfoOverlay').hasClass 'overlayVisible' then $('.itemInfoOverlay').removeClass 'overlayVisible'
    setTimeout ->
      initOverlay()
      getData(type, id).then (res) ->
        generateInfo res
    , 200

  setLightbox = (src, desc) ->
    $('#lightBox').append $('<img class="temp" src="' + src + '" alt="' + desc + '"/>')
    $('#lightBox p').text desc
    $('#lightBox').toggleClass 'showLay'

  initOverlay = ->
    $('.itemInfoOverlay .temp').remove()
    $('.itemInfoOverlay p.value').text ''
    $('.itemInfoOverlay .loading').show()
    $('.itemInfoOverlay').addClass 'overlayVisible'
    $('.itemInfoOverlay .buttonContainer .showcase, .itemInfoOverlay .buttonContainer .parent').addClass 'disabled'
    $('.itemInfoOverlay .buttonContainer .showcase').attr 'href', ''
    $('.itemInfoOverlay .buttonContainer .parent').attr 'target', ''
  
  generateInfo = (data) ->
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
          if res.length != 0
            for child in res
              if $.isArray child.image 
                for elem in child.image
                  data.image.push elem
              else
                data.image.push child.image
              $('.info .child').append $('
                <div class="row temp">
                  <div class="col-lg-8 col-xs-8">
                    <p class="temp">' + child.name + '</p>
                  </div>
                  <div class="col-lg-4 col-xs-4">
                    <button class="temp childTarg" target=item:' + child._id + '>View</button>
                  </div>
                </row>
              ')
            $('.itemInfoOverlay .info .childTarg').one 'click', ->
              linkTo $(this).attr('target').split(':')[0], $(this).attr('target').split(':')[1]
          else
            $('.info .child').append $('<p class="temp">Unavaliable</p>')
          callback()
      else
        $('.info .child').append $('<p class="temp">Unavaliable</p>')
        callback()
    if !$.isArray data.image then data.image = [data.image]
    $('.itemInfoOverlay .info .proj, 
       .itemInfoOverlay .info .team,
       .itemInfoOverlay .info .child
    ').append $('.itemInfoOverlay .loading').clone().removeClass 'main'
    $('.itemInfoOverlay .info .title, .itemInfoOverlay .info .value').show()
    if data.itemType == 'item' && data.parentCollection
      getData('collection', data.parentCollection).then (res) ->
        if res.parentTeam then data.parentTeam = res.parentTeam
        teamInfo ->
          $('.itemInfoOverlay .info .team .loading').fadeOut 500, ->
            $(this).remove()
        $('.itemInfoOverlay .buttonContainer .parent').removeClass('disabled').attr('target', 'collection:' + res._id)
        $('.itemInfoOverlay .col-lg-9 .main').prepend $('<p class="temp"><i>Part of Collection - ' + res.name + '</i></p>')
        $('.itemInfoOverlay .loading.main').fadeOut()
    else if data.itemType == 'item'
      $('.itemInfoOverlay .loading.main').fadeOut()
      teamInfo ->
        $('.itemInfoOverlay .info .team .loading').fadeOut 500, ->
          $(this).remove()
    else
      $('.itemInfoOverlay .loading.main').fadeOut()
    if data.itemType != 'item'
      teamInfo ->
        $('.itemInfoOverlay .info .team .loading').fadeOut 500, ->
          $(this).remove()
    projInfo ->
      $('.itemInfoOverlay .info .proj .loading').fadeOut 500, ->
        $(this).remove()
    childInfo ->
      $('.itemInfoOverlay .info .child .loading').fadeOut 500, ->
        $(this).remove()
        for image in data.image
          $('.itemInfoOverlay .gallery .imgContainer').append $('<div class="imgItem temp">
             <img class="lightBoxItem" src="' + image[0] + '" alt="' + image[1] + '"/>
             <p class="altDesc">' + image[1] + '</p>
           </div>').on 'click', ->
            setLightbox $(this).find('.lightBoxItem').attr('src'), $(this).find('.lightBoxItem').attr('alt')
        if data.itemType == 'item' then $('.itemInfoOverlay .gallery .imgContainer img').css 'max-width', '100%'
        $('.itemInfoOverlay .gallery .imgContainer').imagesLoaded().progress (ins, img) ->
          $(img.img).css 'opacity', 1
        .done ->
          $('.itemInfoOverlay .gallery .imgContainer').rowGrid
            minMargin: 5
            maxMargin: 10
            itemSelector: '.imgItem'
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
      if $('.itemInfoOverlay').hasClass 'overlayVisible' then $('.itemInfoOverlay').removeClass 'overlayVisible'

  $('.itemInfoOverlay .buttonContainer .parent, .itemInfoOverlay .info .childTarg').click ->
    linkTo $(this).attr('target').split(':')[0], $(this).attr('target').split(':')[1]

  infoActive = false
  $('#selectedWorks .work .buttonContainer button').click ->
    if !infoActive || infoActive && $(this).hasClass 'buttonActive'
      $('#selectedWorks .work .info').toggleClass 'showLay hoverable'
      $(this).parent('.buttonContainer').toggleClass('hiddenBg hoverableNext').find('button, a').toggleClass 'dark'
    if !$(this).hasClass 'buttonActive'
      $(this).addClass 'buttonActive'
      $(this).siblings().removeClass 'buttonActive'
    else
      infoActive = !infoActive
    

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

  $('.info.team .close, #lightBox .close').click ->
    $(this).parent().find('.temp').remove()
    $(this).parent().toggleClass 'showLay'

  $('.closeOverlay').click ->
    $('.itemInfoOverlay').removeClass 'overlayVisible'
