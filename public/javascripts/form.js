$(document).ready(function() {

    $('.newfield').click(function(event) {
        event.preventDefault();
        $('form .' + $(this).attr('target')).parent().append(newField($(this).attr('target')));
    });

    $('.edit').click(function() {
        $.ajax({
            url: "/itemdata/edit",
            data: {'name':$(this).attr('attr'), 'index': $(this).attr('item')},
            type: "POST",
            success: function (data) {
                deleteFields();
                insertFields(data);
            }
        });
    });

    function newField(field) {
        var target = 'form .'+ field;
        var newField = $(target).clone();
        newField.attr('name', $(target).attr('name'))
        newField.attr('class', field + $('form input[name="'+ $(target).attr('name') + '"]').length)
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
        var classIndex = 0;
        for (var i = 0; i < dataKeys.length; i++) {
            if (typeof(data[dataKeys[i]]) === 'string') {
                if (typeof(data[dataKeys[i]]) === 'object') {
                    //$('.' + dataKeys[i]) #Todo
                } else {
                    var field = $('form').find('[name=' + dataKeys[i] + ']');
                    field.val(data[dataKeys[i]]);
                }
            }
            else if (typeof(data[dataKeys[i]]) === 'object') {
                var keys = Object.keys(data[dataKeys[i]]);
                var subData = data[dataKeys[i]];
                for (var j = 0; j < keys.length; j++) {
                    var name = '[name="sub' + keys[j] + ',' + dataKeys[i] + '"]';
                    var field = $('form').find(name);
                    field.val(subData[keys[j]]);
                }
            }
        }
    }

});