var express = require('express');
var router = express.Router();
var jade = require('jade');
var database = require('../database');

router.post('/:method', function(req, res, next) {
  if (req.params.method === 'edit') {
    database.getDb().collection('items').find({'_id':database.getID(req.body.id)}).toArray(function(err, result) {
      if (err) {
        throw err;
      } 
      else {
        res.send(result[0]);
      }
    });
  }
  else if (req.params.method === 'delete') {
    database.getDb().collection('items').deleteOne({'_id':database.getID(req.body.id)}, function(err) {
      if (err) throw err;
    });
  }
  else {
    var keys = Object.keys(req.body);
    for(var i = 0; i < keys.length; i++) {
      if (keys[i].indexOf(':') > -1) {
        var key = keys[i].split(':'),
            field = req.body[keys[i]],
            sub = key[1],
            main = key[0];
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
    if (req.body.mode === 'new') {
      delete req.body.mode;
      database.getDb().collection('items').insert(req.body);
    }
    else {
      var modeID = req.body.mode
      delete req.body.mode;
      database.getDb().collection('items').update({'_id':database.getID(modeID)}, req.body);
    }
    res.redirect('back');
  }
});

router.get('/', function(req, res, next) {
  database.getDb().collection('dataTemplates').findOne(function(err, result) {
    var templates = result;
    database.getDb().collection('items').find({}).toArray(function(err, result) {
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

module.exports = router;