var express = require('express');
var path = require('path');
var favicon = require('serve-favicon');
var logger = require('morgan');
var cookieParser = require('cookie-parser');
var bodyParser = require('body-parser');
var lessMiddleware = require('less-middleware');
var mocha = require('mocha');
var cors = require('cors');
var package = require('./package.json');

var app = express();

// routes setup
var index = require('./routes/index');
var portfolio = require('./routes/portfolio');
var showcases = require('./routes/showcases');
var designBlogs = require('./routes/designblogs');
var itemData = require('./routes/itemdata');
var collectionData = require('./routes/collectiondata');
var teamData = require('./routes/teamdata');

// Global vars
app.locals.appVersion = package.version;
app.locals.appAuthor = package.author;
  
// middleware setup
app.use(lessMiddleware(__dirname + '/public', [{
  render: {
    compress: true
  }
}]));
app.use('/bower_components', express.static(__dirname + '/bower_components'));
app.use(cors());

// view engine setup
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'jade');

app.use(favicon(path.join(__dirname, 'public', 'images', 'favicon.ico')));
app.use(logger('dev'));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: false }));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));
app.use('/showcases', express.static(__dirname + '/views/showcases'))

// views setup
app.use('/', index);
app.use('/portfolio', portfolio);
app.use('/showcases', showcases);
app.use('/designblogs', designBlogs);
app.use('/itemdata', itemData);
app.use('/collectiondata', collectionData);
app.use('/teamdata', teamData);

// catch 404 and forward to error handler
app.use(function(req, res, next) {
  var err = new Error('Not Found');
  err.status = 404;
  next(err);
});

// error handler
app.use(function(err, req, res, next) {
  // set locals, only providing error in development
  res.locals.message = err.message;
  res.locals.error = req.app.get('env') === 'development' ? err : {};

  // render the error page
  res.status(err.status || 500);
  res.render('error');
});

module.exports = app;