console.log "If you are that kind of person who prefers the phone, you can call me at +34 615 125 066"

class Binder
  constructor: ()->
    @handlers = {}

  on: (elem, event, fn)=>
    if !@handlers[event] then @handlers[event] = {}
    if !@handlers[event][elem] then @handlers[event][elem] = []
    @handlers[event][elem].push fn
    
    if ( document["addEventListener"] )
      elem["addEventListener"](event, @trigger, false)
    else if ( document["attachEvent"] )
      elem["attachEvent"]('on'+event, @trigger)
    else 
      throw new Error("Event support fail")

  off: (elem, event, fn)->
    if @handlers[event][elem]
      index = -1
      for _fn, i in @handlers[event][elem]
        console.log _fn is fn
        index = i if _fn is fn
      if (index isnt -1)
        @handlers[event][elem].splice(index, 1)

  trigger: (event)=>
    e = event || window.event
    target = if e.target then e.target else e.srcElement
    type = e.type
    for fn in @handlers[type][target]
      fn.call target, @normalize(e) if fn isnt undefined

  normalize: (event)=>
    if (!event.stopPropagation)
      event.stopPropagation = ()->
        this.cancelBubble = true
      event.preventDefault = ()->
        this.returnValue = false;
    if (!event.stop)
      event.stop = ()->
        this.stopPropagation()
        this.preventDefault()
    event

phrases = [
  "I make html and css sites.",
  "I'm in love with javascript.",
  "I like coffescript flavour.",
  "I prefer SASS over LESS.",
  "I think testing is important.",
  "I play with Node.js for fun.",
  "I think Sinatra is awesome!",
  "standards are in my baseline.",
  "I am addicted to chocolate."
]

link = document.getElementById('qualities')
counter = 0

clickHandler = (event)->
  event?.stop()
  link.innerHTML = phrases[counter]
  counter = if counter < phrases.length-1 then counter+1 else 0

_ = new Binder()
_.on(link, 'click', clickHandler)
clickHandler(null)