module.exports = {
  sortDate: (data) ->
    data.sort (a, b) ->
      if a.date && b.date
        a = a.date.split('/').reverse()
        a = new Date a[0], a[1], a[2]
        b = b.date.split('/').reverse()
        b = new Date b[0], b[1], b[2]
        return b - a
}