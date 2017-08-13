var express = require('express');
var router = express.Router();
var jade = require('jade');
var database = require('../database');
var fs = require('fs');

/* GET works page. */
router.get('/', function(req, res, next) {
  database.getDb().collection('items').find({}).toArray(function(err, result) {
    if (err) throw err;
    var data = result;
    res.render('works', { 
      pageContent: data,
      itemKeys: Object.keys(data)
    });
  });
});

router.get('/:id', function(req, res, next) {
  database.getDb().collection('items').find({'_id':database.getID(req.params.id)}).toArray(function(err, result) {
    if (err) throw err;
    var data = result[0];
    var extension;
    if (data.Extended) {
      var file = 'views/extensions/'+req.params.id+'.jade';
      fs.exists(file, function(exists) {
        if (!exists) {
          console.log(exists)
          fs.writeFile(file, 'h3 Extends:'+req.params.id, function (err) {
            if (err) throw err;
            extension = jade.renderFile(file);
            render();
          });
        }
        else {
          extension = jade.renderFile(file);
          render();
        }
      });
    } else {
      render();
    }
    function render() {
      res.render('item', {
        pageContent: data,
        itemKeys: Object.keys(data),
        itemID: req.params.item,
        extension: extension
      });
    }
  });
});

module.exports = router;
