$(document).ready ->
  'use strict'

  $('.newfield').click ->
    field = $(this).parent().find('input:first-of-type')
    $(field).after $(field).clone().css('display', 'block').attr('extra', true).val('')
    return

  $('.new').click ->
    $('#mode-display').text 'Create new item'
    $('#mode').attr 'value', 'new'
    return

  $('.clear').click ->
    clearFields()
    return

  $('.edit').click ->
    parentId = $(this).parent().attr('id')
    $('#mode-display').text 'Editing ' + parentId
    $('#mode').attr 'value', parentId.split(':')[1]
    $.ajax
      url: '/itemdata/edit'
      data: 'id': parentId.split(':')[1]
      type: 'POST'
      success: (data) ->
        clearFields()
        insertFields data
        return
    return
    
  $('.delete').click ->
    parentId = $(this).parent().attr('id')
    $.ajax
      url: '/itemdata/delete'
      data: 'id': parentId.split(':')[1]
      type: 'POST'
    return
  return

  clearFields = ->
    fields = $('input, textarea')
    i = 0
    while i < fields.length
      type = $(fields[i]).attr('type')
      if type == 'hidden' or type == 'submit' or type == 'radio'
      else
        $(fields[i]).val ''
      if $(fields[i]).attr('extra')
        $(fields[i]).remove()
      i++
    return

  insertFields = (data) ->
    dataKeys = Object.keys(data)
    i = 0
    while i < dataKeys.length
      key = dataKeys[i]
      keyData = data[key]
      if typeof keyData == 'string' or key == 'Images'
        addFieldData key, keyData
      else if typeof keyData == 'object'
        key_2 = Object.keys(keyData)
        keyData_2 = keyData
        j = 0
        while j < key_2.length
          addFieldData key + '\\:' + key_2[j], keyData_2[key_2[j]]
          j++
      i++
    return

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
    return