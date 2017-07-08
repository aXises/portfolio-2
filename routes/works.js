var express = require('express');
var router = express.Router();
var jade = require('jade');
var database = require('../database');

/* GET works page. */
database.connectDb(function(err) {
  var db = database.getDb();
  router.get('/', function(req, res, next) {
    db.collection('items').find({}).toArray(function(err, result) {
      if (err) throw err;
      var items = result;
      var data = {};
      var keys = Object.keys(items);
      for (var i = 0; i < items.length; i++) {
        var itemKey = Object.keys(items[i])[1];
        var item = items[i][itemKey];
        data[itemKey] = item;
      };
      res.render('works', { 
        pageContent: data,
        itemKeys: Object.keys(data)
      });
    });
  });

  router.get('/:item', function(req, res, next) {
    db.collection('items').find({}).toArray(function(err, result) {
      if (err) throw err;
      var items = result;
      var data = {};
      var keys = Object.keys(items);
      for (var i = 0; i < items.length; i++) {
        var itemKey = Object.keys(items[i])[1];
        var item = items[i][itemKey];
        data[itemKey] = item;
      }
      var extension;
      if (data[req.params.item.toUpperCase()]['Extended']) {
        extension = jade.renderFile('views/extensions/'+req.params.item+'.extended.jade');
      }
      res.render('item', {
        pageContent: data,
        itemKeys: Object.keys(data),
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
});

module.exports = router;
