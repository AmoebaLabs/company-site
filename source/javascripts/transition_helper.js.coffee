jQuery ($) ->

  class StateTransitionHelper 
    constructor: -> 
      @stateTransitions = new StateTransitions()

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
          oncontact: (event, from, to) =>
             @stateTransitions.contactUsTransition()

          onhome: (event, from, to) =>
            @stateTransitions.homeTransition()

          onteam: (event, from, to) =>
            @stateTransitions.teamTransition()

          # if leaving contact, put it back to home state
          onleavecontact: (event, from, to) =>
              @stateTransitions.undoContactUsTransition();

          # if leaving contact, put it back to home state
          onleaveteam: (event, from, to) =>
              @stateTransitions.undoTeamTransition();
        )

    showContact: -> @stateMachine.contactevt()
    showTeam: -> @stateMachine.teamevt()
    showHome: -> @stateMachine.homeevt()

  window.STH = new StateTransitionHelper()