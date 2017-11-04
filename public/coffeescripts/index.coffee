$(document).ready ->
  'use strict'

  $('.elem-container a').hover ->
    $(this).css 'border-color', '#00bdce'
  , ->
    $(this).css 'border-color', ''

  elemVisible = false
  $(window).scroll ->
    if $('#about .main').offset().top <= $(window).scrollTop() + $(window).height() / 2 && !elemVisible
      $('#about .elem').addClass 'elemVisible'
      elemVisible = true
    $('#index').css 'opacity', 1 - $(window).scrollTop() / 1000

  particlesJS.load 'pbg', 'other/particlesjs.json'