var express = require('express');
var router = express.Router();
var database = require('../routes/database');
var item = require('./item')
var jade = require('jade');
var fs = require('fs');

// console.log(item)

router.get('/', function(req, res, next) {
  database.getDb().collection('items').find({}).toArray(function(err, result) {
    res.render('portfolio', {
      pageContent: result,
      itemKeys: Object.keys(result),
      latest: getItem(result, 'completed'),
      upcoming: getItem(result, 'in progress')
    });
  });
});

function getItem(data, status) {
  var sortedData = data.sort(function(a,b) {
    a = a.Date.split('/').reverse().join('');
    b = b.Date.split('/').reverse().join('');
    return a > b ? 1 : a < b ? -1 : 0;
  });
  sortedData = sortedData.reverse();
  for (var i = 0; i < sortedData.length; i++) {
    if (sortedData[i].Status.toLowerCase() === status) {
      return sortedData[i];
    }
  }
}

router.get('/item/:id', function(req, res, next) {
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
            render('item');
          });
        }
        else {
          extension = jade.renderFile(file);
          render('item');
        }
      });
    } else {
      render('item');
    }
    function render(layout) {
      res.render(layout, {
        pageContent: data,
        itemKeys: Object.keys(data),
        itemID: req.params.item,
        extension: extension
      });
    }
  });
});

module.exports = router;