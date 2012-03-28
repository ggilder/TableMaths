global.window = global

require 'lib/tablemaths'

mockEl = (jqobj, el)->
  obj = {}
  (obj[key] = -> jqobj[key]) for own key, value of jqobj
  (obj.get = -> mockAttr(el)) if el?
  obj

mockAttr = (el)->
  obj = {}
  (obj[key] = el[key]) for own key, value of el
  obj

describe "TableMaths", ->
  it "should be awesome", ->
    expect(TableMaths.version).toEqual "1.0"

describe "Test element validation", ->
  it "should be fun", ->
    el = mockEl({'fun':'whee'}, {'style':{'width':100}})
    expect(el.fun()).toEqual('whee')
    expect(el.get(0).style.width).toEqual(100)
