$(document).ready(function() {
    $('form').submit(function(event) {

    });
    $('.newsub').click(function(event) {
        event.preventDefault();
        var newField = $('#' + $(this).attr('attr')).clone();
        newField.attr('id', '')
        newField.val('');
        $(this).prev().after('<br>');
        $(this).prev().after(newField);
    });
    $('.edit').click(function() {
        $.ajax({
            url: "/newitem/edit",
            data: {'name':$(this).attr('attr'), 'index': $(this).attr('item')},
            type: "POST",
            success: function (data) {
                console.log(data)
            }
        });
    });
});