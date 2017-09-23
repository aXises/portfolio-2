express = require 'express'
router = express.Router()
database = require '../routes/database'
item = require '../routes/item'
  
router.get '/', (req, res, next) ->
  database.getDb().collection('team').find({}).toArray (err, teams) ->
    database.getDb().collection('collection').find({}).toArray (err, collections) ->
      database.getDb().collection('item').find({}).toArray (err, items) ->
        res.render 'teamdata',
          teamKeys: Object.keys(teams),
          teams: teams,
          collectionKeys: Object.keys(collections),
          collections: collections,
          itemKeys: Object.keys(items),
          items: items

module.exports = router