var express = require('express');
var router = express.Router();
var database = require('../database');

/* GET works page. */
router.get('/', function(req, res, next) {
  database.getCollection('data', function(data) {
    res.render('works', { 
      pageContent: data.Projects,
      itemKeys: Object.keys(data.Projects)
    });
  });
});

router.get('/:item', function(req, res, next) {
  database.getCollection('data', function(data) {
    res.render('item', {
      pageContent: data.Projects,
      itemKeys: Object.keys(data.Projects),
      itemID: req.params.item
    }, function(err, page) {
      if (err) {
        console.log('error', err);
        var err;
        if (req.params.item.replace(/[0-9]/g, '') === "item") {
          err = new Error('NotImplementedError');
          err.status = 404;
        }
        else {
          err = new Error('UndefinedPage');
          err.status = 404;
        }
        next(err);
      }
      else {
        res.end(page);
      }
    });
  });
});


module.exports = router;
