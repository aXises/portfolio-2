var MongoClient = require('mongodb').MongoClient;
var URICS = "mongodb://tonyli139:RDyMScAWKpj0Fl1O@p2cluster-shard-00-00-ccvtw.mongodb.net:27017,p2cluster-shard-00-01-ccvtw.mongodb.net:27017,p2cluster-shard-00-02-ccvtw.mongodb.net:27017/<DATABASE>?ssl=true&replicaSet=p2Cluster-shard-0&authSource=admin";
var db;

connectDb = function(callback) {
	MongoClient.connect(URICS, function(err, database) {
		if (err) throw err;
		db = database;
		//console.log(db)
		console.log('connected');
		return callback(err);
	});
}

getDb = function() {
	return db;
}

insertCollection = function (collection, data) {
	db.collection(collection).insert(data).then(function(result) {
		console.log('Added to', collection);
	});
}

getCollection = function(collection, callback) {
	db.collection(collection).findOne({}, function(err, result) {
		if (err) throw err;
		console.log('Got', collection);
		callback(result);
	});
}

replaceCollection = function(collection, data) {
	db.collection(collection).replaceOne({}, data, function() {
		console.log('Replaced', collection);
	});
}

module.exports = {
	insertCollection,
	getCollection,
	replaceCollection,
	connectDb,
	getDb
}

