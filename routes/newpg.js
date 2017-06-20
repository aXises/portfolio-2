var express = require('express');
var router = express.Router();
var fs = require('fs');

/* GET home page. */
router.get('/', function(req, res, next) {
  var data = JSON.parse(fs.readFileSync('routes/data.json', 'utf8'))
  res.render('index', { 
    title: 'NEW PAGE',
    navLinks: data.navLinks
  });
});

module.exports = router;
