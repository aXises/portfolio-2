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

module.exports = router;
