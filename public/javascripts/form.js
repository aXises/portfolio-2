$(document).ready(function() {

    $('.newfield').click(function(event) {
        event.preventDefault();
        $('form .' + $(this).attr('target')).parent().append(newField($(this).attr('target')));
    });

    $('.edit').click(function() {
        $.ajax({
            url: "/itemdata/edit",
            data: {'name':$(this).attr('attr'), 'id': $(this).attr('id')},
            type: "POST",
            success: function (data) {
                deleteFields();
                insertFields(data);
            }
        });
    });

    $('.delete').click(function() {
        $.ajax({
            url: "/itemdata/delete",
            data: {'name':$(this).attr('attr'), 'id': $(this).attr('id')},
            type: "POST"
        });
    });

    function newField(field) {
        var target = 'form .'+ field;
        var newField = $(target).clone();
        newField.attr({
            'name': $(target).attr('name'),
            'class': field + $('form input[name="'+ $(target).attr('name') + '"]').length,
            'new': true
        });
        newField.val('');
        return newField;
    }

    function deleteFields() {
        var fields = $('input');
        for (var i = 0; i < fields.length; i++) {
            if ($(fields[i]).attr('new')) {
                $(fields[i]).remove();
            }
        }
    }

    function insertFields(data) {
        var dataKeys = Object.keys(data);
        for (var i = 0; i < dataKeys.length; i++) {
            if (typeof(data[dataKeys[i]]) === 'string') {
                var field = $('form').find('[name=' + dataKeys[i] + ']');
                field.val(data[dataKeys[i]]);
            }
            else if (typeof(data[dataKeys[i]]) === 'object') {
                if (dataKeys[i] === 'Images') {
                    $('form').find('[name=' + dataKeys[i] + ']').val(data[dataKeys[i]].shift());
                    data[dataKeys[i]].forEach(function(element) {
                        $('#Images').append(newField(dataKeys[i]).val(element));
                    }, this);
                }
                else { 
                    var keys = Object.keys(data[dataKeys[i]]);
                    var subData = data[dataKeys[i]];
                    for (var j = 0; j < keys.length; j++) {
                        var selec = $('button[target="' + keys[j] + '"]');
                        var name = '[name="sub' + keys[j] + ',' + dataKeys[i] + '"]';
                        var field = $('form').find(name);
                        if (typeof(subData[keys[j]]) === 'object') {
                            $(field).val(subData[keys[j]].shift());
                            subData[keys[j]].forEach(function(element) {
                                selec.parent().append(newField(keys[j]).val(element));
                            }, this);
                        }
                        else {
                            field.val(subData[keys[j]]);
                        }
                    }
                }
            }
            
        }
    }

});