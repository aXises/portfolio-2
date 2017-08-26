var express = require('express');
var router = express.Router();
var database = require('../database');

/* GET home page. */
router.get('/', function(req, res, next) {
  database.getDb().collection('items').find({}).toArray(function(err, result) {
    res.render('index', {
      title: 'Axisesio'
    });
  });
});

module.exports = router;