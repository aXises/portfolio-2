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

router.get('/Works', function(req, res, next) {
  var data = JSON.parse(fs.readFileSync('routes/data.json', 'utf8'))
  res.render('works', { 
    navLinks: links,
    pageContent: data.Projects,
    itemKeys: Object.keys(data.Projects)
  });
});

router.get('/:item', function(req, res, next) {
  res.render('item', {
    navLinks: links,
    pageContent: data.Projects,
    itemKeys: Object.keys(data.Projects),
    itemID: req.params.item
  })
});

module.exports = router;
