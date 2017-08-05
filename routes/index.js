var express = require('express');
var router = express.Router();
var database = require('../database');

/* GET home page. */
database.connectDb(function(err) {
  if (err) throw err;
  var db = database.getDb();
  db.collection('items').find({}).toArray(function(err, result) {
    router.get('/', function(req, res, next) {
      res.render('index', {
        title: 'Axisesio',
        latest: getItem(result, 'completed'),
        upcoming: getItem(result, 'in progress')
      });
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
      console.log(sortedData[i]);
      return sortedData[i];
    }
  }
}

module.exports = router;