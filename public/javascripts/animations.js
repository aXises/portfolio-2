function indexanimate() {
    move('.text-container')
<<<<<<< HEAD
    .ease('in-out')
    .set('top', '50px')
    .set('opacity', 1)
    .duration('1s')
=======
    .set('top', '50px')
    .set('opacity', '1')
    .duration('1s')
    .ease('in-out')
>>>>>>> refs/remotes/origin/staging
    .end(function() {
        move('.text-container')
        .set('letter-spacing', '5px')
        .set('left', '85%')
        .set('transform', 'translateX(0)')
        .duration('1.2s')
        .ease('in-out')
        .end();
    });
}

function galleryanimate() {
    move('.text-container')
<<<<<<< HEAD
    .ease('in-out')
=======
>>>>>>> refs/remotes/origin/staging
    .set('left', '95%')
    .set('letter-spacing', 'normal')
    .set('opacity', '1')
    .duration('1s')
<<<<<<< HEAD
    .end();
}
=======
    .ease('in-out')
    .end();
}

function itemanimate() {
    move('.item-container')
    .ease('in-out')
    .set('opacity', '1')
    .set('padding-top', '0')
    .duration('1s')
    .end();
}

>>>>>>> refs/remotes/origin/staging
