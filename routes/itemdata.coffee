express = require 'express'
router = express.Router()
database = require '../routes/database'
item = require '../routes/item'

convertToArrayIfNot = (field) ->
  if typeof(field) != 'object' then return [field] else return field

getDelta = (arr1, arr2) ->
  res = arr1.filter((x) => arr2.indexOf(x) == -1)
  if !(res[0]) then return null else return res

UpdateAdjacent = (incomingCollection, incomingId, incomingParam, remoteCollection, remoteParam, updateParam) ->
  db = database.getDb()
  db.collection(incomingCollection).find({'_id': database.getId(incomingId)}).toArray (err, result) ->
    if (getDelta(incomingParam, result[0][remoteParam]))
      console.log 'adding', getDelta(incomingParam, result[0][remoteParam])
      if getDelta(incomingParam, result[0][remoteParam]).length >= 1
        itemDiff = getDelta incomingParam, result[0][remoteParam]
        for itemId in itemDiff
          query = {
                    '_id': database.getId itemId
                  }
          queryParam = {
            $set:{}
          }
          queryParam['$set'][updateParam] = incomingId
          db.collection(remoteCollection).findOneAndUpdate query, queryParam
          console.log 'adding', query, queryParam
    if (getDelta(result[0][remoteParam], incomingParam))
      console.log 'removing', getDelta(result[0][remoteParam], incomingParam)
      if getDelta(result[0][remoteParam], incomingParam).length >= 1
        itemDiff = getDelta result[0].hasItems, incomingParam
        for itemId in itemDiff
          query = {
                    '_id': database.getId itemId
                  }
          queryParam = {
            $set:{}
          }
          queryParam['$set'][updateParam] = ''
          db.collection(remoteCollection).findOneAndUpdate query, queryParam
          console.log 'removing', query, queryParam
router.post '/newItem', (req, res, next) ->
  db = database.getDb()
  newItem = new item.item database.getId(), req.body.name, req.body.status, req.body.type, req.body.link, req.body.description, req.body.date, req.body.technologies, req.body.images
  db.collection('collection').find({'_id':database.getId(req.body.collection)}).toArray (err, result) ->
    currentCollection = new item.collection result[0]._id, result[0].name, result[0].status, result[0].type, result[0].link, result[0].description, result[0].image, result[0].hasItems
    newItem.setCollection currentCollection
    db.collection('collection').update {'_id':database.getId(req.body.collection)}, currentCollection
    db.collection('item').insert newItem, ->
      res.redirect 'back'

router.post '/newCollection', (req, res, next) ->
  db = database.getDb()
  newCollection = new item.collection database.getId(), req.body.name, req.body.status, req.body.type, req.body.link, req.body.description, req.body.image, req.body.items, req.body.showcase
  db.collection('collection').insert newCollection, ->
    res.redirect 'back'

router.post '/newTeam', (req, res, next) ->
  db = database.getDb()
  newTeam = new item.team database.getId(), req.body.name, req.body.logo, req.body.link, req.body.description, req.body.showcase, req.body.members
  if req.body.hasCollections
    req.body.hasCollections = convertToArrayIfNot(req.body.hasCollections)
    UpdateAdjacent 'team', teamId, req.body.hasCollections, 'collection', 'hasCollections', 'partOfTeam'
  if req.body.hasItems
    req.body.hasItems = convertToArrayIfNot(req.body.hasItems)
    UpdateAdjacent 'team', teamId, req.body.hasItems, 'item', 'hasItems', 'partOfTeam'
  db.collection('team').insert newTeam, ->
    res.redirect 'back'

router.post '/update/:collection/:id', (req, res, next) ->
  db = database.getDb()
  collection = db.collection(req.params.collection)

  updateItem = (itemId, data) ->
    return

  updateCollection = (collectionId, data) ->
    return

  updateTeam = (teamId, data) ->
    collection.find({'_id': database.getId(teamId)}).toArray (err, result) ->
      data.hasItems = convertToArrayIfNot(data.hasItems)
      UpdateAdjacent 'team', teamId, data.hasItems, 'item', result[0].hasItems, 'partOfTeam'
      data.hasCollections = convertToArrayIfNot(data.hasCollections)
      UpdateAdjacent 'team', teamId, data.hasCollections, 'collection', 'hasCollections', 'partOfTeam'
      collection.findOneAndUpdate(
        {
          '_id': database.getId(teamId)
        },
        {
          $set: data
        }
      )
    
    # collection.find({'_id': database.getId(teamId)}).toArray (err, result) ->
    #   if getDelta(data.hasItems, result[0].hasItems).length >= 1
    #     itemDiff = getDelta(data.hasItems, result[0].hasItems)
    #     for itemId in itemDiff
    #       db.collection('item').findOneAndUpdate(
    #         {
    #           '_id': database.getId(itemId)
    #         },
    #         {
    #           $set: {
    #             'partOfTeam': req.params.id
    #           }
    #         }
    #       )
    #   else if getDelta(result[0].hasItems, data.hasItems).length >= 1
    #     itemDiff = getDelta(result[0].hasItems, data.hasItems)
    #     for itemId in itemDiff
    #       db.collection('item').findOneAndUpdate(
    #         {
    #           '_id': database.getId(itemId)
    #         },
    #         {
    #           $set: {
    #             'partOfTeam': ''
    #           }
    #         }
    #       )
    #   collection.findOneAndUpdate(
    #     {
    #       '_id': database.getId(req.params.id)
    #     },
    #     {
    #       $set: data
    #     }
    #   )
      
  switch req.params.collection
    when 'item' then updateItem(req.params.id, req.body)
    when 'collection' then updateCollection(req.params.id, req.body)
    when 'team' then updateTeam(req.params.id, req.body)
    else
      throw new ReferenceError()

  res.redirect 'back'

router.post '/delete/:collection', (req, res, next) ->
  database.getDb().collection(req.params.collection).findOneAndDelete({'_id': database.getId(req.body.id)})
  res.redirect 'back'

router.post '/getData/:collection', (req, res, next) ->
  db = database.getDb()
  db.collection(req.params.collection).find({'_id':database.getId(req.body.id)}).toArray (err, result) ->
    res.send(result[0])

router.post '/updateItem/:id', (req, res, next) ->
  db = database.getDb()
  db.collection('item').find({'_id':database.getId(req.params.id)}).toArray (err, result) ->
    editedItem = new item.item database.getId(req.params.id), req.body.name, req.body.status, req.body.type, req.body.link, req.body.description, req.body.date, req.body.technologies, req.body.images
    if req.body.collection
      db.collection('collection').find({'_id':database.getId(req.body.collection)}).toArray (err, result) ->
        currentCollection = new item.collection result[0]._id, result[0].name, result[0].status, result[0].type, result[0].link, result[0].description, result[0].image, result[0].hasItems
        editedItem.setCollection currentCollection
        db.collection('collection').update {'_id':database.getId(req.body.collection)}, currentCollection, ->
          db.collection('item').update {'_id':database.getId(req.params.id)}, editedItem, ->
            res.redirect 'back'
    else
      db.collection('item').update {'_id':database.getId(req.params.id)}, editedItem, ->
        res.redirect 'back'

router.post '/deleteItem', (req, res, next) ->
  db = database.getDb()
  db.collection('item').find({'_id':database.getId(req.body.id)}).toArray (err, result) ->
    if result[0].collection[0]

      itemId = req.body.id
      db.collection('collection').find({'_id':database.getId(result[0].collection[0])}).toArray (err, result) ->
        updatedItemList = []
        for id in result[0].hasItems
          if itemId != String(id)
            updatedItemList.push(id)
        currentCollection = new item.collection result[0]._id, result[0].name, result[0].status, result[0].type, result[0].link, result[0].description, result[0].image, updatedItemList
        db.collection('collection').update {'_id':database.getId(result[0]._id)}, currentCollection, ->
          db.collection('item').remove {'_id':database.getId(req.body.id)}, ->
            res.redirect('back')
    else
      db.collection('item').remove {'_id':database.getId(req.body.id)}, ->
        res.redirect 'back'

router.post '/deleteCollection', (req, res, next) ->
  db = database.getDb()
  db.collection('collection').find({'_id':database.getId(req.body.id)}).toArray (err, result) ->
    if result[0].hasItems.length > 0
      for itemIds in result[0].hasItems
        db.collection('item').find({'_id':database.getId(itemIds)}).toArray (err, result) ->
          currentItem = new item.item result[0]._id, result[0].name, result[0].status, result[0].type, result[0].link, result[0].description, result[0].date, result[0].technologies, result[0].images
          db.collection('item').update {'_id':database.getId(result[0]._id)}, currentItem
      db.collection('collection').remove {'_id':database.getId(req.body.id)}, ->
        res.redirect 'back'
    else
      db.collection('collection').remove {'_id':database.getId(req.body.id)}, ->
        res.redirect 'back'

router.get '/', (req, res, next) ->
  database.getDb().collection('item').find({}).toArray (err, items) ->
    database.getDb().collection('collection').find({}).toArray (err, collections) ->
      res.render 'itemdata',
        itemKeys: Object.keys items
        items: items
        collectionKeys: Object.keys collections
        collections: collections

module.exports = router