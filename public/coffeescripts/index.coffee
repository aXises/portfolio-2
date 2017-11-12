randInt = (min, max) ->
    Math.floor(Math.random() * (max - min + 1)) + min

class imgSlide

  constructor: (@elem) ->
    @index = 0
    @total = 0
    @images = $(@elem).find 'img'
    @seqs = $(@elem).find '.slideSeq .seq'

  autoTransit: (method) ->
    self = this
    bar = $(self.elem).find '.bar'
    interval = randInt 3000, 9000
    if method == 'stop'
      clearInterval @transition
      bar.stop()
    else
      bar.css 'width', '100%'
      bar.animate {
        width: 0;
      }, interval, 'swing', ->
        bar.css 'width', '100%'
      @transition = setInterval ->
        self.next()
        bar.animate {
          width: 0;
        }, interval, 'swing', ->
          bar.css 'width', '100%'
        interval = randInt 3000, 9000
      , interval

  init: ->
    for image, i in @images
      $(image).attr('index', i)
      $(@seqs[i]).attr('index', i)
      @total += 1
    this.autoTransit()

  next: ->
    $(@images[@index]).removeClass 'active'
    $(@seqs[@index]).removeClass 'active'
    @index += 1
    @index = @index % @total
    $(@seqs[@index]).addClass 'active'
    $(@images[@index]).addClass 'active'
  
  setIndex: (index) ->
    @index = index
    $(@seqs[index]).siblings('.seq').removeClass 'active'
    $(@images[index]).siblings('img').removeClass 'active'
    $(@seqs[index]).addClass 'active'
    $(@images[index]).addClass 'active'

$(document).ready ->
  'use strict'

  $('.elem-container a').hover ->
    $(this).css 'border-color', '#00bdce'
  , ->
    $(this).css 'border-color', ''

  colSlide = new imgSlide $('#about .imgContainer.col')
  rowSlide = new imgSlide $('#about .imgContainer.side')
  colSlide.init()
  rowSlide.init()

  $('.imgContainer.col .slideSeq .seq').click ->
    colSlide.setIndex $(this).attr 'index'
    colSlide.autoTransit 'stop'
    setTimeout ->
      colSlide.autoTransit()
    , 5000

  $('.imgContainer.side .slideSeq .seq').click ->
    rowSlide.setIndex $(this).attr 'index'
    rowSlide.autoTransit 'stop'
    setTimeout ->
      rowSlide.autoTransit()
    , 5000
    
  $(window).scroll ->
     $('#index').css 'opacity', 1 - $(window).scrollTop() / 1000

  particlesJS.load 'pbg', 'other/particlesjs.json'


