class baseItem
  constructor: (@name, @status, @type, @link) ->
    @childrens
    
  setName: (name) ->
    @name = name
    return

  setStatus: (status) ->
    @status = status
    return

  setType: (type) ->
    @type = type
    return

  setLink: (link) ->
    @link = link
    return

  addChild: (child) ->
    @child.puuh(child)
    return

class item extends baseItem
  constructor: (@parent) ->

  setParent: (@parent) ->
    @parent = @parent
    @parent.addChild(@parent)
    return

class collection extends baseItem
  constructor: (@items) ->

  addItem: (@item) ->
    @items.push(@item)
    return

module.exports = {
  baseItem,
  item,
  collection
}