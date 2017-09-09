// Generated by CoffeeScript 1.12.7
(function() {
  $(document).ready(function() {
    'use strict';
    var addFieldData, clearFields, insertFields;
    clearFields = function() {
      var fields, i, type;
      fields = $('input, textarea');
      i = 0;
      while (i < fields.length) {
        type = $(fields[i]).attr('type');
        if (type === 'hidden' || type === 'submit' || type === 'radio') {

        } else {
          $(fields[i]).val('');
        }
        if ($(fields[i]).attr('extra')) {
          $(fields[i]).remove();
        }
        i++;
      }
    };
    insertFields = function(data) {
      var dataKeys, i, j, key, keyData, keyData_2, key_2;
      dataKeys = Object.keys(data);
      i = 0;
      while (i < dataKeys.length) {
        key = dataKeys[i];
        keyData = data[key];
        if (typeof keyData === 'string' || key === 'Images') {
          addFieldData(key, keyData);
        } else if (typeof keyData === 'object') {
          key_2 = Object.keys(keyData);
          keyData_2 = keyData;
          j = 0;
          while (j < key_2.length) {
            addFieldData(key + '\\:' + key_2[j], keyData_2[key_2[j]]);
            j++;
          }
        }
        i++;
      }
    };
    addFieldData = function(key, data) {
      var field, i;
      field = $('form').find('#' + key).children('[name=' + key + ']');
      if (!Array.isArray(data)) {
        field.val(data);
      } else {
        data = data.reverse();
        $(field).val(data.pop());
        i = 0;
        while (i < data.length) {
          $(field).after($(field).clone().css('display', 'block').attr('extra', true).val(data[i]));
          i++;
        }
      }
    };
    $('.newfield').click(function() {
      var field;
      field = $(this).parent().find('input:first-of-type');
      $(field).after($(field).clone().css('display', 'block').attr('extra', true).val(''));
    });
    $('.new').click(function() {
      $('#mode-display').text('Create new item');
      $('#mode').attr('value', 'new');
    });
    $('.clear').click(function() {
      clearFields();
    });
    $('.edit').click(function() {
      var parentId;
      parentId = $(this).parent().attr('id');
      $('#mode-display').text('Editing ' + parentId);
      $('#mode').attr('value', parentId.split(':')[1]);
      $.ajax({
        url: '/itemdata/getItem',
        data: {
          'id': parentId.split(':')[1]
        },
        type: 'POST',
        success: function(data) {
          console.log(data);
          clearFields();
          insertFields(data);
        }
      });
    });
    $('.delete').click(function() {
      var parentId;
      parentId = $(this).parent().attr('id');
      $.ajax({
        url: '/itemdata/delete',
        data: {
          'id': parentId.split(':')[1]
        },
        type: 'POST'
      });
    });
  });

}).call(this);