$(document).ready(function() {

    var navActive;

    var mainNav = $('.nav-main ul li');
    var secNav = $('.nav-secondary ul li span');

    for (var i = 0; i < mainNav.length; i++) {
        $(mainNav[i]).attr('target', '#nav-span'+i);
        $(secNav[i]).attr('id', 'nav-span'+i);
    }
    
    $('.nav-main ul li').hover(
        function() {
            var target = $($(this).attr('target'))
            target.parent().css({
                'background-color': '#dadad2',
            });
            target.css('color', '#333333');
        }, function() {
            var target = $($(this).attr('target'))
            target.parent().css({
                'background-color': '',
            });
            target.css('color', '');
        });

    $('.nav-menu, .nav-close').click(function() {
        navToggle()
    });

    function navToggle() {
        if (!navActive) {
            $('.nav-main, .nav-secondary').css('left', '0px');
            $('.nav-menu').css({
                left: '-80px',
                opacity: '0',
                cursor: 'default'
            });
        } else {
            $('.nav-main, .nav-secondary').css('left', '');
            $('.nav-menu').css({
                left: '',
                opacity: '',
                cursor: ''
            });
        }
        navActive = !navActive
    }

}); // End of use
