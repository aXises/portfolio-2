MongoClient = require('mongodb').MongoClient;
ObjectID = require('mongodb').ObjectID;
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
