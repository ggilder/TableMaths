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
# pending

describe "td validations", ->
  describe "empty width attribute validation", ->
    it "should warn on empty width attr", ->
      
    it "should pass with width attr", ->

    it "should ignore non-td elements", ->


#  it "should warn on empty width attribute", ->
#    el = mockEl({'fun':'whee'}, {'style':{'width':100}})
#    expect(el.fun()).toEqual('whee')
#    expect(el.get(0).style.width).toEqual(100)
#
# Pending validations
# table/td: warning: empty width attr
# table/td: error: percentage width attr/css with padding
# table/td: warning: percentage width (except root table)
# table/td: error: width attr/css not matching actual width
# tr: error: valign attribute (maybe css too?)
# td: error: mismatched vertical padding across row
# td: error: incorrect colspan/rowspan
# table: warning: no width attr or css

