express = require 'express'
router = express.Router()
database = require '../routes/database'

convertToArrayIfNot = (field) ->
  if typeof(field) != 'object' then return [field] else return field

getDelta = (arr1, arr2) ->
  res = arr1.filter((x) => arr2.indexOf(x) == -1)
  if !(res[0]) then return null else return res

router.get '/', (req, res, next) ->
  database.getDb().collection('item').find({}).toArray (err, items) ->
    database.getDb().collection('collection').find({}).toArray (err, collections) ->
      res.render 'itemdata',
        itemKeys: Object.keys items
        items: items
        collectionKeys: Object.keys collections
        collections: collections

module.exports = router