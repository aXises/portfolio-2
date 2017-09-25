MongoClient = require('mongodb').MongoClient;
ObjectID = require('mongodb').ObjectID;
URICS = "mongodb://tonyli139:RDyMScAWKpj0Fl1O@p2cluster-shard-00-00-ccvtw.mongodb.net:27017,p2cluster-shard-00-01-ccvtw.mongodb.net:27017,p2cluster-shard-00-02-ccvtw.mongodb.net:27017/<DATABASE>?ssl=true&replicaSet=p2Cluster-shard-0&authSource=admin";
db = null

connectDb = (callback) ->
  MongoClient.connect URICS, (err, database) ->
    if err 
      throw err
    db = database
    return callback(err)

getDb = ->
  if db.serverConfig.isConnected()
    return db
  else
    throw 'No connection to mongoAtlas'

getId = (id) ->
  return new ObjectID(id)

module.exports = {
	connectDb,
	getDb,
	getId
}