var express = require('express');
var router = express.Router();
var fs = require('fs');
/* GET home page. */
router.get('/', function(req, res, next) {
  var data = JSON.parse(fs.readFileSync('routes/data.json', 'utf8'))
  res.render('gallery', { 
    navLinks: data.navLinks,
    pageContent: data.Projects,
    itemKeys: Object.keys(data.Projects)
  });
});

module.exports = router;