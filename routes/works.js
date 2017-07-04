var express = require('express');
var router = express.Router();
var jade = require('jade');
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
    var extension;
    if (data.Projects[req.params.item.toUpperCase()]['Extended']) {
      extension = jade.renderFile('views/extensions/'+req.params.item+'.extended.jade');
    }
    res.render('item', {
      pageContent: data.Projects,
      itemKeys: Object.keys(data.Projects),
      itemID: req.params.item,
      extension: extension
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
