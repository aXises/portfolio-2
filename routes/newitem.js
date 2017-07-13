var express = require('express');
var router = express.Router();
var jade = require('jade');
var database = require('../database');

database.connectDb(function(err) {
  if (err) throw err;
  var db = database.getDb();
  router.post('/', function(req, res, next) {
    var keys = Object.keys(req.body);
    for(var i = 0; i < keys.length; i++) {
      if (keys[i].substring(0,3) === 'sub') {
        var key = keys[i].split(','),
            field = req.body[keys[i]],
            sub = key[0].substring(3),
            main = key[1];
        if (typeof(req.body[main]) === 'undefined') {
          req.body[main] = {};
        }
        req.body[main][sub] = field;
        delete req.body[keys[i]];
      }
    }
    var extended = req.body.Extended
    req.body.Extended = extended === 'true' ? true : false;
    if (typeof(req.body.Images) !== 'object') {
      req.body['Image'] = req.body.Images
    }
    req.body['Image'] = req.body.Images[0]
    db.collection('items').find({}).toArray(function(err, result) {
      var items = result,
          itemSize = items.length,
          item = {};
      item['ITEM'+(itemSize+1)] = req.body;
      db.collection('items').insert(item);
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