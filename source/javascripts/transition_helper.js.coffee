//= require state-machine

jQuery ($) ->

  class StateTransitionHelper 
    constructor: -> 
      @stateMachine = StateMachine.create(
        initial: "home"

        events: [
          name: "contactevt"
          from: "*"
          to: "contact"
        ,
          name: "homeevt"
          from: "*"
          to: "home"
        ,
          name: "teamevt"
          from: "*"
          to: "team"
        ]

        callbacks:
          oncontact: (event, from, to) ->
             transitions.contactUsTransition()

          onhome: (event, from, to) ->
            transitions.homeTransition()

          onteam: (event, from, to) ->
            transitions.teamTransition()
        )

    showContact: -> @stateMachine.contactevt()
    showTeam: -> @stateMachine.teamevt()
    showHome: -> @stateMachine.homeevt()

  window.STH = new StateTransitionHelper()