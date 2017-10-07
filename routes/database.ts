var MongoClient = require('mongodb').MongoClient;
var ObjectID = require('mongodb').ObjectID;
var fs = require('fs');
var async = require('async');
var URICS: string;
var db;

URICS = "mongodb://p2:7P69W3bWUvzHJY1h@p2cluster-shard-00-00-ccvtw.mongodb.net:27017,p2cluster-shard-00-01-ccvtw.mongodb.net:27017,p2cluster-shard-00-02-ccvtw.mongodb.net:27017/<DATABASE>?ssl=true&replicaSet=p2Cluster-shard-0&authSource=admin";

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
			fs.mkdirSync(path);
		};
		async.parallel([
			function(callback) {
				if (!fs.existsSync(path + '/index.html')) {
					fs.writeFile(path + '/index.jade', 'div Markup for ' + data.name + ' ' + id, function(err) {
						if (err) throw err;
						callback()
					})
				}
			},
			function(callback) {
				if (!fs.existsSync(path + '/style.css')) {
					fs.writeFile(path + '/style.css', '/* Stylesheet for ' + data.name + ' ' + id +' */', function(err) {
						if (err) throw err;
						callback()
					})
				}
			},
			function(callback) {
				if (!fs.existsSync(path + '/script.js')) {
					fs.writeFile(path + '/script.js', '// Script for ' + data.name + ' ' + id, function(err) {
						if (err) throw err;
						callback()
					})
				}
			},
			function(callback) {
				fs.writeFile(path + '/data.json', JSON.stringify(data), function(err) {
					if (err) throw err;
					callback()
				})
			}
		], function () {
			console.log('generated files')
		});
  }
};

