(function() {
  var Binder, clickHandler, counter, link, phrases, _,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  console.log("If you are that kind of person who prefers the phone, you can call me at +34 615 125 066");

  Binder = (function() {
    function Binder() {
      this.normalize = __bind(this.normalize, this);
      this.trigger = __bind(this.trigger, this);
      this.on = __bind(this.on, this);      this.handlers = {};
    }

    Binder.prototype.on = function(elem, event, fn) {
      if (!this.handlers[event]) {
        this.handlers[event] = {};
      }
      if (!this.handlers[event][elem]) {
        this.handlers[event][elem] = [];
      }
      this.handlers[event][elem].push(fn);
      if (document["addEventListener"]) {
        return elem["addEventListener"](event, this.trigger, false);
      } else if (document["attachEvent"]) {
        return elem["attachEvent"]('on' + event, this.trigger);
      } else {
        throw new Error("Event support fail");
      }
    };

    Binder.prototype.off = function(elem, event, fn) {
      var i, index, _fn, _i, _len, _ref;

      if (this.handlers[event][elem]) {
        index = -1;
        _ref = this.handlers[event][elem];
        for (i = _i = 0, _len = _ref.length; _i < _len; i = ++_i) {
          _fn = _ref[i];
          console.log(_fn === fn);
          if (_fn === fn) {
            index = i;
          }
        }
        if (index !== -1) {
          return this.handlers[event][elem].splice(index, 1);
        }
      }
    };

    Binder.prototype.trigger = function(event) {
      var e, fn, target, type, _i, _len, _ref, _results;

      e = event || window.event;
      target = e.target ? e.target : e.srcElement;
      type = e.type;
      _ref = this.handlers[type][target];
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        fn = _ref[_i];
        if (fn !== void 0) {
          _results.push(fn.call(target, this.normalize(e)));
        } else {
          _results.push(void 0);
        }
      }
      return _results;
    };

    Binder.prototype.normalize = function(event) {
      if (!event.stopPropagation) {
        event.stopPropagation = function() {
          return this.cancelBubble = true;
        };
        event.preventDefault = function() {
          return this.returnValue = false;
        };
      }
      if (!event.stop) {
        event.stop = function() {
          this.stopPropagation();
          return this.preventDefault();
        };
      }
      return event;
    };

    return Binder;

  })();

  phrases = ["I make html and css sites.", "I'm in love with javascript.", "I like coffescript flavour.", "I prefer SASS over LESS.", "I think testing is important.", "I play with Node.js for fun.", "I think Sinatra is awesome!", "standards are in my baseline.", "I am addicted to chocolate."];

  link = document.getElementById('qualities');

  counter = 0;

  clickHandler = function(event) {
    if (event != null) {
      event.stop();
    }
    link.innerHTML = phrases[counter];
    return counter = counter < phrases.length - 1 ? counter + 1 : 0;
  };

  _ = new Binder();

  _.on(link, 'click', clickHandler);

  clickHandler(null);

}).call(this);
