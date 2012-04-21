###
Table Maths!
© 2011 Traction
By Gabriel Gilder, 2011/11/10
###

class window.TableMaths
  constructor: ->
    @loading_start = 0
    @loading_interval = 100
    @loading_max = 10
    @cache = []
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
    @cache[@tag_index] = e
    out = $("<p>").append(e.eq(0).clone()).html()
    parts = out.split '>', 2
    out = parts[0] + '>'
    out = out.replace('<','&lt;').replace('>','&gt;')
    out = '<span class="tmhl-tag" style="cursor:help;" cacheidx="' + @tag_index + '">' + out + '</span>'

  highlightEl: (e) ->
    p = e.offset()
    $('#tmhl').css('left',p.left).css('top',p.top).width(e.width()).height(e.height()).show()

  run: ->
    return unless @browserValid?
    UI.setup()
    alert "derp... not done yet"

  report: ->
    @init()
    
  browserValid: ->
    if $.browser.opera || $.browser.msie
      alert("Sorry, TableMaths doesn't work with your browser. Please try Firefox, Safari, or Chrome.")
  
  class Validation
    constructor: (@tags, @validator) ->
    test: (el) ->

  class UI
    @setup: ->
      unless $('#tablemaths').length > 0
        $('body').append('<div id="tmhl" style="display:none;background-color:#9cf;opacity:0.75;position:absolute;z-index:999;"></div>')
        $('body').append('<div id="tablemaths" style="z-index:9999;position:fixed;top:15px;left:15px;border:1px solid #000;background-color:#ff9;font-family:Lucida Grande,Helvetica,Arial;font-size:10px;padding:5px;width:450px;overflow:hidden;cursor:move;"><h1 style="font-size:16px;font-weight:bold;margin:0 0 12px 0;">TableMaths '+TableMaths.version+'</h1><div class="report"></div><div id="tmrs" class="ui-resizable-handle ui-resizable-se" style="position:absolute;bottom:5px;right:5px;background-image:url(http://traction.github.com/TableMaths/handle.png);width:11px;height:11px;cursor:se-resize;"></div></div>')
        $('#tablemaths').draggable().resizable({ handles: {se:'#tmrs'} })
        $('.tmhl-tag').live 'mouseover mouseout', (event) ->
          if event.type == 'mouseout'
            $('#tmhl').hide()
          else
            $tm.highlightEl($tm.cache[$(this).attr('cacheidx')])
        
TableMaths.version = '1.0'

if document?
  $tm = new TableMaths
  $tm.report()



###
  run : function(){
    
    
    this.cache = [];
    i=0;
    err=0;
    warn=0;
    report=''
    
    $('table,td').each(function(idx,el){
      var e=$(el);
      var x=e.attr('width');
      if(x !== undefined){
        var w=e.width();
        if (x.trim() === '') {
          report += 'Warning! Empty width attribute on tag:<br/>';
          report += $tablemaths.tagHtml(e)+'<br/><br/>';
          warn++;
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
