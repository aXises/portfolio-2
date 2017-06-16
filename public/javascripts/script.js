$(document).ready(function() {

    var navActive;

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
