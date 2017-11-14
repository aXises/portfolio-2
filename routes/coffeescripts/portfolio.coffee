express = require 'express'
router = express.Router()
database = require '../routes/database'
utilFunc = require '../routes/utilFunc'
async = require 'async'

router.get '/', (req, res, next) ->
  db = database.getDb()
  colDatas = []
  db.collection('collection').find({
    featured: 'true'
  }).toArray (err, collections) ->
    async.each collections, (colData, callback) ->
      getCollectionSize = (cb) -> 
        db.collection('item').find({
          parentCollection: colData._id.toString()
        }).toArray (err, items) ->
          cb(items.length)
      if colData.parentTeam
        db.collection('team').find({
          _id: database.getId colData.parentTeam
        }).toArray (err, teamData) ->
          colData.parentTeamData = teamData[0]
          getCollectionSize (size) ->
            colData.collectionSize = size
            colDatas.push(colData)
            callback()
      else
        getCollectionSize (size) ->
          colData.collectionSize = size
          colDatas.push(colData)
          callback()
    , (err) ->
      db.collection('item').find({}).toArray (err, allItems) ->
        db.collection('collection').find({}).toArray (err, allCollections) ->
          res.render 'portfolio', {
            title: 'AXISESIO'
            selectedCollections: utilFunc.sortDate(colDatas),
            items: utilFunc.sortDate(allItems.concat(allCollections))
          }

module.exports = router