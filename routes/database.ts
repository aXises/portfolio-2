var MongoClient = require('mongodb').MongoClient;
var ObjectID = require('mongodb').ObjectID;
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
  generateShowcase: function(type: string, data) {
    console.log(type, data)
  }
}

