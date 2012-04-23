global.window = global

require 'lib/tablemaths'

mockEl = (tagName, jqobj, el)->
  obj = {}
  obj.parents = -> []
  (obj[key] = jqobj[key]) for own key, value of jqobj
  obj.get = -> mockAttr(el, tagName)
  obj

mockAttr = (el, tagName)->
  obj = {tagName: tagName}
  (obj[key] = el[key]) for own key, value of el
  obj

# describe "TableMaths", ->
# pending

describe "width validations", ->
  describe "empty width attribute validation", ->
    subject = TableMaths.validations.emptyWidthValidation
    it "should pass with no width attr", ->
      result = subject.test(mockEl('td'))
      expect(result.passed).toBe(true)
    it "should pass with regular width attr", ->
      result = subject.test(mockEl('td', {}, {width:'100'}))
      expect(result.passed).toBe(true)
    it "should warn on td with empty width attr", ->
      result = subject.test(mockEl('td', {}, {width:''}))
      expect(result.passed).toBe(false)
      expect(result.level).toBe('Warning')
    it "should warn on table with empty width attr", ->
      result = subject.test(mockEl('table', {}, {width:''}))
      expect(result.passed).toBe(false)
      expect(result.level).toBe('Warning')
    it "should ignore tags besides td and table", ->
      result = subject.test(mockEl('div'))
      expect(result.passed).toBe(true)
 
  describe "percentage width validation", ->
    subject = TableMaths.validations.percentageWidthValidation
    defaultDomTree = {parents: -> ['table']}
    it "should pass with no width attr", ->
      result = subject.test(mockEl('td'))
      expect(result.passed).toBe(true)
    it "should warn on td with percentage width attr", ->
      result = subject.test(mockEl('td', defaultDomTree, {width:'10%'}))
      expect(result.passed).toBe(false)
      expect(result.level).toBe('Warning')
    it "should warn on td with percentage width in inline style", ->
      result = subject.test(mockEl('td', defaultDomTree, {style:{width:'10%'}}))
      expect(result.passed).toBe(false)
      expect(result.level).toBe('Warning')
    it "should pass on root table with percentage width attr", ->
      result = subject.test(mockEl('table', {}, {style:{width:'100%'}}))
      expect(result.passed).toBe(true)
    it "should warn on non-root table with percentage width css", ->
      result = subject.test(mockEl('table', defaultDomTree, {style:{width:'100%'}}))
      expect(result.passed).toBe(false)
      expect(result.level).toBe('Warning')

# Pending validations
# table/td: error: percentage width attr/css with padding
# table/td: error: width attr/css not matching actual width
# tr: error: valign attribute (maybe css too?)
# td: error: mismatched vertical padding across row
# td: error: incorrect colspan/rowspan
# table: warning: no width attr or css

# Probably not possible without lots of hackery:
# percentage width css on table/td (besides inline)
# accurate width css (besides inline)
