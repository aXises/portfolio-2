function indexanimate() {
    move('.text-container')
    .set('top', '50px')
    .set('opacity', '1')
    .duration('1s')
    .ease('in-out')
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
    .set('left', '95%')
    .set('letter-spacing', 'normal')
    .set('opacity', '1')
    .duration('1s')
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

