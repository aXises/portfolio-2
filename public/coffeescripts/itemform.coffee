$(document).ready ->
  'use strict'

  clearFields = ->
    fields = $('input, textarea')
    i = 0
    while i < fields.length
      type = $(fields[i]).attr('type')
      if type == 'hidden' or type == 'submit' or type == 'radio' or type == 'checkbox'
      else
        $(fields[i]).val ''
      if $(fields[i]).attr('extra')
        $(fields[i]).remove()
      i++

  insertFields = (data) ->
    dataKeys = Object.keys(data)
    for key in Object.keys(data)
      addFieldData key, data[key]
    if data.parentCollection
      for radio in $('#partOfCollection input')
        if data.parentCollection == $(radio).val()
          $(radio).prop('checked', true)
    if data.showcase == 'true' then $('#extended input[value="true"]').prop 'checked', true else $('#extended input[value="false"]').prop 'checked', true
    if data.featured == 'true' then $('#featured input[value="true"]').prop 'checked', true else $('#featured input[value="false"]').prop 'checked', true

  addFieldData = (key, data) ->
    field = $('form').find('#' + key).children('[name=' + key + ']')
    if !Array.isArray(data)
      field.val data
    else
      data = data.reverse()
      $(field).val data.pop()
      i = 0
      while i < data.length
        $(field).after $(field).clone().css('display', 'block').attr('extra', true).val(data[i])
        i++
    
  $('.newfield').click ->
    field = $(this).parent().find('input:first-of-type')
    $(field).after $(field).clone().css('display', 'block').attr('extra', true).val('')

  $('.new').click ->
    $('#mode-display').text 'Create new item'
    $('form').attr 'action', 'itemdata/new'

  $('.clear').click ->
    clearFields()

  $('.edit').click ->
    parentId = $(this).parent().attr('id')
    itemId = parentId.split(':')[1]
    $('form').attr 'action', 'itemdata/update/' + itemId
    $('#mode-display').text 'Editing ' + parentId
    $.ajax
      url: '/itemdata/getData'
      data: 'id': itemId
      type: 'POST'
      success: (data) ->
        clearFields()
        insertFields data
    
  $('.delete').click ->
    parentId = $(this).parent().attr('id')
    if confirm 'delete ' + parentId + '?'
      $.ajax
        url: '/itemdata/delete'
        data: 'id': parentId.split(':')[1]
        type: 'POST',
        success: (res) ->
          if res
            location.reload()
