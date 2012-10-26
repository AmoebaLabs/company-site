//= require state-machine

(function (window) {

  var PSM = function() {

    var fsm = StateMachine.create({
      initial: 'home',

      events: [
        { name: 'contactevt', from: 'home',   to: 'contact'  },
      ],

      callbacks: {
        onbeforecontactevt: function(event, from, to) { console.log("STARTING UP"); },
        oncontactevt:       function(event, from, to) { console.log("READY");       },
  
        onleavecontact:  function(event, from, to) { console.log("LEAVE   STATE: contact");  },
        onleavehome: function(event, from, to) { console.log("LEAVE   STATE: home"); },
        
        oncontact:       function(event, from, to) { console.log("ENTER   STATE: contact");  },
        onhome:      function(event, from, to) { console.log("ENTER   STATE: home"); },
       
        onchangestate: function(event, from, to) { console.log("CHANGED STATE: " + from + " to " + to); }
      }
    });

    return fsm;
  }();

  window.PSM = PSM;

}(this));