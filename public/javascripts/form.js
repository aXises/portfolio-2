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
});