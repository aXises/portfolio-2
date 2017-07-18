var express = require('express');
var router = express.Router();
var jade = require('jade');
var database = require('../database');

database.connectDb(function(err) {
  if (err) throw err;
  var db = database.getDb();
  router.get('/', function(req, res, next) {
    db.collection('dataTemplates').findOne(function(err, result) {
      var templates = result;
      db.collection('items').find({}).toArray(function(err, result) {
        var items = result;
        res.render('edititem', { 
          items: items,
          itemKeys: Object.keys(items),
          template: templates["Project"],
          templateKeys: Object.keys(templates["Project"])
        });
      });
    });
  });
});

module.exports = router;