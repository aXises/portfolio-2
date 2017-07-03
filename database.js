var MongoClient = require('mongodb').MongoClient;
var fs = require('fs');
var URICS = "mongodb://tonyli139:RDyMScAWKpj0Fl1O@p2cluster-shard-00-00-ccvtw.mongodb.net:27017,p2cluster-shard-00-01-ccvtw.mongodb.net:27017,p2cluster-shard-00-02-ccvtw.mongodb.net:27017/<DATABASE>?ssl=true&replicaSet=p2Cluster-shard-0&authSource=admin";

insertFile = function (collection, file) {
	var data = JSON.parse(fs.readFileSync(file, 'utf8'))
	MongoClient.connect(URICS, function(err, db) {
		if (err) throw err;
		db.collection(collection).insert(data).then(function(result) {
			if (err) throw err;
			console.log('Added to', collection);
		});
		db.close();
	});
}

getCollection = function(collection, callback) {
	console.log('test')
	MongoClient.connect(URICS, function(err, db) {
		db.collection('data').findOne({}, function(err, result) {
			if (err) throw err;
			callback(result);
		});
		db.close();
	});
}

module.exports = {
	insertFile,
	getCollection
}

