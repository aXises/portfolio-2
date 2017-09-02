class baseItem
  constructor: (@_id, @name, @status, @type, @link) ->

class item extends baseItem
  setCollection: (collection) ->
    collection.addItem(this._id)
    @collection = collection._id
    return

class collection extends baseItem
  constructor: (@_id, @name, @status, @type, @link) ->
    super(@_id, @name, @status, @type, @link)
    @childrens = []

  addItem: (items) ->
    @childrens.push(items)
    return

class team
  constructor: (@name, @logo, @members, @site) ->

  addMember: (members) ->
    if typeof(members == 'object')
      for member in members
        @members.push(member)
    else
      @members.push(member)
    return

module.exports = {
  item,
  collection
}