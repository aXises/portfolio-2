var express = require('express');
var router = express.Router();
var jade = require('jade');
var database = require('../database');

database.connectDb(function(err) {
  if (err) throw err;
  var db = database.getDb();
  router.post('/:method', function(req, res, next) {
    if (req.params.method === 'edit') {
      db.collection('items').find({'_id':database.getID(req.body.id)}).toArray(function(err, result) {
        if (err) {
          throw err;
        } 
        else {
          res.send(result[0]);
        }
      });
    }
    else {
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
      req.body['Image'] = req.body.Images[0]
      if (typeof(req.body.Images) !== 'object') {
        req.body['Image'] = req.body.Images
      }
      //processField(req.body);
      //db.collection('items').insert(req.body);
      console.log(req.body)
      res.redirect('/works');
    }
  });

  router.get('/', function(req, res, next) {
    db.collection('dataTemplates').findOne(function(err, result) {
      var templates = result;
      db.collection('items').find({}).toArray(function(err, result) {
        var items = result;
        res.render('itemdata', { 
          itemKeys: Object.keys(items),
          items: items,
          template: templates["Project"],
          templateKeys: Object.keys(templates["Project"])
        });
      });
    });
  });
});

function processField(data) {
  var keys = Object.keys(data);
  var fields = [];
  for (var i = 0; i < keys.length; i++) {
    if (typeof(data[keys[i]]) === 'object') {
       fields.push(processField(data[keys[i]]));
    }
    else {
      fields.push(data[keys[i]]);
    }
  }
  return fields;
}

module.exports = router;