$(document).ready(function () {
  'use strict';

  $('.newfield').click(function () {
    var field = $(this).parent().find('input:first-of-type');
    $(field).after($(field).clone().css('display', 'block').attr('extra', true).val(''));
  });

  $('.new').click(function () {
    $('#mode-display').text('Create new item');
    $('#mode').attr('value', 'new');
    clearFields();
  });

  $('.edit').click(function () {
    var parentId = $(this).parent().attr('id');
    $('#mode-display').text('Editing '+parentId );
    $('#mode').attr('value', parentId.split(':')[1]);
    $.ajax({
      url: '/itemdata/edit',
      data: { 'id': parentId.split(':')[1] },
      type: 'POST',
      success: function (data) {
        //console.log(data)
        clearFields();
        insertFields(data);
      }
    });
  });

  $('.delete').click(function () {
    var parentId = $(this).parent().attr('id');
    $.ajax({
      url: '/itemdata/delete',
      data: { 'id': parentId.split(':')[1] },
      type: 'POST'
    });
  });

  function clearFields() {
    var fields = $('input, textarea');
    for (var i = 0; i < fields.length; i++) {
      if ($(fields[i]).attr('type') !== 'hidden') {
        $(fields[i]).val('');
      }
      if ($(fields[i]).attr('extra')) {
        $(fields[i]).remove();
      }
    }
  }

  function insertFields(data) {
    var dataKeys = Object.keys(data);
    for (var i = 0; i < dataKeys.length; i++) {
      var key = dataKeys[i]
      var keyData = data[key]
      if (typeof (keyData) === 'string' || key === 'Images') {
        addFieldData(key, keyData)
      }
      else if (typeof (keyData) === 'object') {
        var key_2 = Object.keys(keyData)
        var keyData_2 = keyData 
        for (var j = 0; j < key_2.length; j++) {
          console.log(key_2[j])
          addFieldData(key +'\\:'+ key_2[j], keyData_2[key_2[j]]);   
        }
      }
    }
  }

  function addFieldData(key, data) {
    var field = $('form').find('#'+key).children('[name='+key+']');
    if (!Array.isArray(data)) {
      field.val(data);
    }
    else {
      data = data.reverse()
      $(field).val(data.pop())
      for (var i = 0; i < data.length; i++) {
        $(field).after($(field).clone().css('display', 'block').attr('extra', true).val(data[i]));
      }
    }
  }

});