###
Table Maths!
© 2011 Traction
By Gabriel Gilder, 2011/11/10
###

$tm = class window.TableMaths
  @cache = []

  @highlightEl: (e) ->
    p = e.offset()
    $('#tmhl').css('left',p.left).css('top',p.top).width(e.width()).height(e.height()).show()
    
  constructor: ->
    @loading_start = 0
    @loading_interval = 100
    @loading_max = 10
    @tag_index = 0

  init: ->
    @loading_start = (new Date).getTime()
    @addScript('http://ajax.googleapis.com/ajax/libs/jquery/1.7/jquery.min.js')
    @addScript('http://ajax.googleapis.com/ajax/libs/jqueryui/1.8.16/jquery-ui.min.js')
    setTimeout ( => @prerun()), @loading_interval
  
  addScript: (src) ->
    t = document.createElement 'script'
    t.setAttribute 'src', src
    document.body.appendChild t
  
  prerun: ->
    unless $? && $.fn.draggable?
      if ((new Date).getTime() - @loading_start) > @loading_max * 1000
        alert "Waited for #{@loading_max} seconds and jQuery/jQuery UI are not loaded yet. Giving up... sorry! Waaaa!"
      else
        console.log "jquery or jquery ui not loaded; waiting another #{@loading_interval}ms..."
        setTimeout ( => @prerun()), @loading_interval
    else
      @run()
  
  tagHtml: (e) ->
    @tag_index++
    $tm.cache[@tag_index] = e
    out = $("<p>").append(e.eq(0).clone()).html()
    parts = out.split '>', 2
    out = parts[0] + '>'
    out = out.replace('<','&lt;').replace('>','&gt;')
    out = '<span class="tmhl-tag" style="cursor:help;" cacheidx="' + @tag_index + '">' + out + '</span>'

  run: ->
    return unless @browserValid?
    new $tm.UI()
    alert "derp... not done yet"

  report: ->
    @init()
    
  browserValid: ->
    if $.browser.opera || $.browser.msie
      alert("Sorry, TableMaths doesn't work with your browser. Please try Firefox, Safari, or Chrome.")
        
class $tm.Element
  constructor: (@el) ->
    @domEl = @el.get(0)
    @tagName = @domEl.tagName
  widthAttr: ->
    @domEl.width?.trim()
  widthCss: (el)->
    @domEl.style?.width or ''
  parents: ->
    @el.parents.apply(@el, arguments)

class $tm.Validation
  constructor: (@tags, @validator) ->
  validTag: (tag) -> @tags.indexOf(tag.toLowerCase()) != -1
  test: (el) ->
    el = new $tm.Element(el)
    return new $tm.ValidationResult.Pass() unless @validTag(el.tagName)
    @validator(el)

class $tm.ValidationResult
  constructor: (@passed, @level, @message) ->
    @passed = !!@passed

class $tm.ValidationResult.Pass extends $tm.ValidationResult
  constructor: ->
    super(true)

class $tm.ValidationResult.Warning extends $tm.ValidationResult
  constructor: (message) ->
    super(false, 'Warning', message)
    
class $tm.UI
  constructor: ->
    unless $('#tablemaths').length > 0
      $('body').append('<div id="tmhl" style="display:none;background-color:#9cf;opacity:0.75;position:absolute;z-index:999;"></div>')
      $('body').append('<div id="tablemaths" style="z-index:9999;position:fixed;top:15px;left:15px;border:1px solid #000;background-color:#ff9;font-family:Lucida Grande,Helvetica,Arial;font-size:10px;padding:5px;width:450px;overflow:hidden;cursor:move;"><h1 style="font-size:16px;font-weight:bold;margin:0 0 12px 0;">TableMaths '+$tm.version+'</h1><div class="report"></div><div id="tmrs" class="ui-resizable-handle ui-resizable-se" style="position:absolute;bottom:5px;right:5px;background-image:url(http://traction.github.com/TableMaths/handle.png);width:11px;height:11px;cursor:se-resize;"></div></div>')
      $('#tablemaths').draggable().resizable({ handles: {se:'#tmrs'} })
      $('.tmhl-tag').live 'mouseover mouseout', (event) ->
        if event.type == 'mouseout'
          $('#tmhl').hide()
        else
          $tm.highlightEl($tm.cache[$(this).attr('cacheidx')])
             
$tm.version = '1.0'
$tm.validations = {}
(->
  v = $tm.validations
  pass = $tm.ValidationResult.Pass
  warn = $tm.ValidationResult.Warning
  v.emptyWidthValidation = new $tm.Validation ['td','table'], (el) ->
    if el.widthAttr() is ''
      new warn 'Empty width attribute'
    else
      new pass
  v.percentageWidthValidation = new $tm.Validation ['td','table'], (el) ->
    attr = el.widthAttr()
    css = el.widthCss()
    if el.parents('table').length == 0
      new pass
    else if attr? and attr.slice(-1) is '%'
      new warn 'Percentage width attribute'
    else if css.slice(-1) is '%'
      new warn 'Percentage width in inline style'
    else
      new pass
)()
(new $tm()).report() if document?
###
        } else if (x.substring(x.length-1)=='%'){
          if (parseInt(e.css('padding-left')) || parseInt(e.css('padding-right'))) {
            report += 'Error! Tag with percentage width and padding:<br/>';
            report += $tablemaths.tagHtml(e)+'<br/><br/>';
            err++;
          } else if (e.parents('table').length > 0) { // ignores tables that aren't nested
            report += 'Warning! Percentage width on tag:<br/>';
            report += $tablemaths.tagHtml(e)+'<br/><br/>';
            warn++;
          }
        } else if (w!=x) {
          report += 'Incorrect width on tag:<br/>';
          report += $tablemaths.tagHtml(e)+'<br/>';
          report += x+' specified, '+w+' actual<br/><br/>';
          err++;
        }
      }
      i++;
    });
    $('tr').each(function(idx,el){
      var e=$(el);
      if(e.attr('valign')){
        report += 'Warning! valign on tr tags is ignored in some email clients.<br/>'
        report += $tablemaths.tagHtml(e)+'<br/>';
        warn++;
      }
      var tds = e.find('> td');
      var pad_top = tds.map(function(){return parseInt($(this).css('padding-top'), 10);});
      i++;
    });
    report = '<b>'+i+' tags scanned, '+err+' errors, '+warn+' warnings.</b><br/><br/>'+report+'Enjoy your maths!';
    
  },
###
