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
    return

  insertFields = (data) ->
    dataKeys = Object.keys(data)
    if data.hasItems
      for id in data.hasItems
        for checkbox in $('#hasItems input')
          if id == $(checkbox).val()
            $(checkbox).prop('checked', true)
            break
    if data.hasCollections
      for id in data.hasCollections
        for checkbox in $('#hasCollections input')
          if id == $(checkbox).val()
            $(checkbox).prop('checked', true)
            break
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
    
  $('.newfield').click ->
    field = $(this).parent().find('input:first-of-type')
    $(field).after $(field).clone().css('display', 'block').attr('extra', true).val('')
    return

  $('.new').click ->
    $('#mode-display').text 'Create new team'
    $('form').attr 'action', 'teamdata/new'
    return

  $('.clear').click ->
    clearFields()
    return

  $('.edit').click ->
    parentId = $(this).parent().attr('id')
    itemId = parentId.split(':')[1]
    $('form').attr 'action', 'teamdata/update/' + itemId
    $('#mode-display').text 'Editing ' + parentId
    $.ajax
      url: '/teamdata/getData'
      data: 'id': itemId
      type: 'POST'
      success: (data) ->
        clearFields()
        insertFields data
        return
    return
    
  $('.delete').click ->
    parentId = $(this).parent().attr('id')
    $.ajax
      url: '/teamdata/delete'
      data: 'id': parentId.split(':')[1]
      type: 'POST',
      success: (res) ->
        if res
          location.reload()
    return
  return
