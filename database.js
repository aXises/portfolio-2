var MongoClient = require('mongodb').MongoClient;
var URICS = "mongodb://tonyli139:RDyMScAWKpj0Fl1O@p2cluster-shard-00-00-ccvtw.mongodb.net:27017,p2cluster-shard-00-01-ccvtw.mongodb.net:27017,p2cluster-shard-00-02-ccvtw.mongodb.net:27017/<DATABASE>?ssl=true&replicaSet=p2Cluster-shard-0&authSource=admin";

insertCollection = function (collection, data) {
	MongoClient.connect(URICS, function(err, db) {
		if (err) throw err;
		db.collection(collection).insert(data).then(function(result) {
			console.log('Added to', collection);
		});
		db.close();
	});
}

getCollection = function(collection, callback) {
	MongoClient.connect(URICS, function(err, db) {
		if (err) throw err;
		db.collection(collection).findOne({}, function(err, result) {
			if (err) throw err;
			console.log('Got', collection);
			callback(result);
		});
		db.close();
	});
}

replaceCollection = function(collection, data) {
	MongoClient.connect(URICS, function(err, db) {
		if (err) throw err;
		db.collection('data').replaceOne({}, data, function() {
			console.log('Replaced', collection);
		});
		db.close();
	});
}

module.exports = {
	insertCollection,
	getCollection,
	replaceCollection
}

