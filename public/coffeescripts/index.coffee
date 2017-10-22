$(document).ready ->
  'use strict'

  $('.elem-container a').hover ->
    $(this).css 'border-color', '#00bdce'
  , ->
    $(this).css 'border-color', ''

  particlesJS.load 'pbg', 'other/particlesjs.json'