function indexanimate() {
    move('.text-container')
    .ease('in-out')
    .set('top', '50px')
    .set('opacity', 1)
    .duration('1s')
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
    .ease('in-out')
    .set('left', '95%')
    .set('letter-spacing', 'normal')
    .set('opacity', '1')
    .duration('1s')
    .end();
}