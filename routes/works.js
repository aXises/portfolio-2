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
      var data = result;
      res.render('works', { 
        pageContent: data,
        itemKeys: Object.keys(data)
      });
    });
  });

  router.get('/:item', function(req, res, next) {
    db.collection('items').find({}).toArray(function(err, result) {
      if (err) throw err;
      var data = result[parseInt(req.params.item.substr(-1))];
      var extension;
      if (data.Extended) {
        //extension = jade.renderFile('views/extensions/'+req.params.item+'.extended.jade');
        extension = jade.renderFile('views/extensions/test.extended.jade');
      }
      res.render('item', {
        pageContent: data,
        itemKeys: Object.keys(data),
        itemID: req.params.item,
        extension: extension
      });
    });
  });
});

module.exports = router;
