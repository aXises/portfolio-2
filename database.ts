var MongoClient = require('mongodb').MongoClient;
var ObjectID = require('mongodb').ObjectID;
var URICS: string;
var db;


function connectDb(callback) {
	MongoClient.connect(URICS, function(err, database) {
		if (err) throw err;
		db = database;
		//console.log('connected');
		return callback(err);
	});
}

function getDb() {
	if (db.serverConfig.isConnected()) {
		return db;
  }
  
	else {
		throw 'No connection';
	}
}

function getId(id: string) {
	return new ObjectID(id);
}

module.exports = {
	connectDb,
	getDb,
	getId
}

