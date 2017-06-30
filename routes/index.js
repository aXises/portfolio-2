var express = require('express');
var router = express.Router();
var fs = require('fs');
var data = JSON.parse(fs.readFileSync('routes/data.json', 'utf8'))
var links = data.navLinks

/* GET home page. */
router.get('/', function(req, res, next) {
  res.render('index', { 
    title: 'Axisesio',
    navLinks: links
  });
});

module.exports = router;
