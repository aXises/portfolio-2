express = require 'express'
router = express.Router()
database = require '../routes/database'
item = require '../routes/item'

router.get '/', (req, res, next) ->
  db = database.getDb()
  #db.collection('collection').remove()
  #db.collection('item').remove()
  #db.collection('team').remove()
  db.collection('item').find({}).toArray (err, res) ->
    console.log 'item', res
  db.collection('collection').find({}).toArray (err, res) ->
    console.log 'collection', res
  db.collection('team').find({}).toArray (err, res) ->
    console.log 'team', res
  res.render 'index', {
    title: 'AXISIO'
  }

module.exports = router