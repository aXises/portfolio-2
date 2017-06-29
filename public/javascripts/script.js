$(document).ready(function() {

    if (document.location.pathname.split('/').pop().slice(0, -1) === 'item') {
        prepAnimationItem();
    }
    
    function prepAnimationItem() {
        $('.item-container').css({
            'padding-top': '50px',
            'opacity': 0
        });
    }

    $(document).imagesLoaded().always(function() {
        load();
    });

    $(window).resize(function() {
        setAside();
    });

    $('#display img').hover(
        function() {
            $(this).next('aside').css('opacity', '1');
            $(this).css({
                'transform': 'scale(1.05)',
                'filter': 'blur(2px)'
            });
        }, 
        function() {
            $(this).next('aside').css('opacity', '');
            $(this).css({
                'transform': '',
                'filter': ''
            });
        }
    );
    
    var aTag = $('nav a');

    for (var i = 0; i < aTag.length; i++) {
        var link = $(aTag[i]);
        if (link.attr('href').charAt(0) === '#') {
            link.children('li').text(link.children('li').text().slice(1))
        }
    }

    $('nav a').click(function(event) {
        event.preventDefault();
        var pageHash = this.hash
        var pageHref = this.href
        if (pageHash.charAt(0) === '#') {
            if (window.location.pathname === '/') {
                $('html, body').animate({
                    scrollTop: $(pageHash).offset().top
                }, 800, function(){
                    window.location.hash = pageHash;
                });
            }
            else {
                pageHash = this.hash
                redirect();
            }
        }
        else {
            pageHref = this.href
            redirect();
        }
        function redirect() {
            $('body').fadeOut(750, function() {
                if (pageHash !== '') {
                    window.location = '/' + pageHash;
                }
                else {
                    window.location = pageHref;
                }
            });
        }
    });

    var mainNav = $('.nav-main ul li');
    var secNav = $('.nav-secondary ul li span');

    for (var i = 0; i < mainNav.length; i++) {
        $(mainNav[i]).attr('target', '#nav-span'+i);
        $(secNav[i]).attr('id', 'nav-span'+i);
    }
    
    $('.nav-main ul li').hover(
        function() {
            var target = $($(this).attr('target'));
            target.parent().css({
                'background-color': '#dadad2',
            });
            target.css('color', '#333333');
        }, 
        function() {
            var target = $($(this).attr('target'));
            target.parent().css({
                'background-color': '',
            });
            target.css('color', '');
        }
    );

    $('.nav-main ul').hover(
        function() {
            $('.nav-main').css('background-color', 'rgba(0, 0, 0, 0.7)');
        }, 
        function() {
            $('.nav-main').css('background-color', '');
        }
    );

    var navActive;

    $('.nav-menu, .nav-close').click(function() {
        navToggle();
    });

    function navToggle() {
        if (!navActive) {
            $('.nav-main, .nav-secondary').css('left', '0px');
            $('.nav-menu').css({
                left: '-80px',
                opacity: '0',
                cursor: 'default'
            });
        }
        else {
            $('.nav-main, .nav-secondary').css('left', '');
            $('.nav-menu').css({
                left: '',
                opacity: '',
                cursor: ''
            });
        }
        navActive = !navActive
    }

    function setAside () {
        
        var displayImg = $('#display img');

        for (var i = 0; i < displayImg.length; i++) {
            var img = $(displayImg[i]);
            img.next('aside').css('height', img.height())
            img.next('aside').css('width', img.width())
        }
    }

    function load() {
        $('body').css('overflow-y', 'auto');
        $('#loading').css({
            'opacity': 0,
            'pointer-events': 'none',
        });

        $.getScript('../javascripts/animations.js', function() {
            if (document.location.pathname === '/') {
                indexanimate();
            }
            else if (document.location.pathname === '/Works') {
                galleryanimate();
            }
            else if (document.location.pathname.split('/').pop().slice(0, -1) === 'item') {
                itemanimate();
            }
        });

        setAside();
    }

}); // End of use