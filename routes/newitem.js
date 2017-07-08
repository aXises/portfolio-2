var express = require('express');
var router = express.Router();
var jade = require('jade');
var database = require('../database');

database.connectDb(function(err) {
  if (err) throw err;
  var db = database.getDb();
  router.post('/', function(req, res, next) {
    db.collection('items').find({}).toArray(function(err, result) {
      var items = result;
      var itemSize = items.length;
      var item = {};
      item['ITEM'+(itemSize+1)] = req.body;
      db.collection('items').insert(item)
      res.redirect('/newitem');
    });
  });

  router.get('/', function(req, res, next) {
    db.collection('dataTemplates').findOne(function(err, result) {
      var templates = result;
      db.collection('items').find({}).toArray(function(err, result) {
        var items = result;
        res.render('newitem', { 
          itemKeys: Object.keys(items),
          template: templates["Project"],
          templateKeys: Object.keys(templates["Project"])
        });
      });
    });
  });
});

module.exports = router;