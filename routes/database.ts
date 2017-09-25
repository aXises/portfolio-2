var MongoClient = require('mongodb').MongoClient;
var ObjectID = require('mongodb').ObjectID;
var fs = require('fs');
var async = require('async');
var URICS: string;
var db;


module.exports = {
	connectDb: function connectDb(callback) {
		MongoClient.connect(URICS, function(err, database) {
			if (err) throw err;
			db = database;
			return callback(err);
		});
	},
	getDb: function getDb() {
		if (db.serverConfig.isConnected()) {
			return db;
		}
		else {
			throw 'No connection';
		}
	},
  getId: function(id: string) {
		return new ObjectID(id);
	},
  generateShowcase: function(type: string, id: string, data) {
		var path =  __dirname + '/../views/showcases/' + type + '/' + id 
		if (!fs.existsSync(path)) {
				console.log('test')
			fs.mkdirSync(path);
		};
		async.parallel([
			function(callback) {
				if (!fs.existsSync(path + '/index.html')) {
					fs.writeFile(path + '/index.html', '<div>Markup for ' + data.name + ' ' + id +'</div>', function(err) {
						if (err) throw err;
					})
				}
			},
			function(callback) {
				if (!fs.existsSync(path + '/style.css')) {
					fs.writeFile(path + '/style.css', '/* Stylesheet for ' + data.name + ' ' + id +' */', function(err) {
						if (err) throw err;
					})
				}
			},
			function(callback) {
				if (!fs.existsSync(path + '/script.js')) {
					fs.writeFile(path + '/script.js', '// Script for ' + data.name + ' ' + id, function(err) {
						if (err) throw err;
					})
				}
			},
			function(callback) {
				fs.writeFile(path + '/data.json', JSON.stringify(data), function(err) {
					if (err) throw err;
				})
			}
		]);
  }
};

