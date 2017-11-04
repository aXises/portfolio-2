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
    if data.parentTeam
      for radio in $('#partOfTeam input')
        if data.parentTeam == $(radio).val()
          $(radio).prop('checked', true)
    if data.showcase == 'true' then $('#extended input[value="true"]').prop 'checked', true else $('#extended input[value="false"]').prop 'checked', true
    if data.featured == 'true' then $('#featured input[value="true"]').prop 'checked', true else $('#featured input[value="false"]').prop 'checked', true
    for key in Object.keys(data)
      addFieldData key, data[key]

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
    $('#mode-display').text 'Create new collection'
    $('form').attr 'action', 'collectiondata/new'
    return

  $('.clear').click ->
    clearFields()
    return

  $('.edit').click ->
    parentId = $(this).parent().attr('id')
    itemId = parentId.split(':')[1]
    $('form').attr 'action', 'collectiondata/update/' + itemId
    $('#mode-display').text 'Editing ' + parentId
    $.ajax
      url: '/collectiondata/getData'
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
      url: '/collectiondata/delete'
      data: 'id': parentId.split(':')[1]
      type: 'POST',
      success: ->
        location.reload()
    return
  return
    if confirm 'delete ' + parentId + '?'
      $.ajax
        url: '/collectiondata/delete'
        data: 'id': parentId.split(':')[1]
        type: 'POST',
        success: (res) ->
          if res
            location.reload()
