
class AmoebaSite.Views.Homepage.Presentation extends Amoeba.View
  name: 'presentation'
  el: '#presentation'

  initialize: ->
    this._setupProgressBar()

  transitionIn: (from) ->
    # When from is 'none' this is an initial page load, so animate instantly
    animationTime = if from is 'none' then 0 else @parent.animationTime

    @helpers.scrollToTop(animationTime)
    @parent.hideFooter(animationTime)
    @parent.mascot.hide(animationTime)

    this._openCurtains(true)

    @$el.disolveIn(0)

  transitionOut: (to) ->
    animationTime = @parent.animationTime

    if AmoebaSite.presentation?
      AmoebaSite.presentation.tearDown()
      AmoebaSite.presentation = undefined

    # Hide presentation, also sets hidden class
    @$el.disolveOut(0)

  _setupProgressBar: () =>
    @progressIndex = 0
    @progressSteps = 6

     # progress bar at bottom
    $('<div/>')
      .appendTo(@el)
      .attr({id: "progressBar"})
      .html('<span></span>')
      .click( (event) =>
        console.log 'clicked progress bar'
      )

    # listen for events to increment progress
    $('body').on('amoeba:incrementProgressBar', =>
      @progressIndex++

      ratio = @progressIndex / (@progressSteps - 1)

      $("#progressBar span").css(width: "#{ratio * window.innerWidth}px")
    )

  _openCurtains: (showPresentation) =>
    if showPresentation
      curtains = new AmoebaSite.Curtains($("body"), false, (step) =>
        switch step
          when '2'
            if not AmoebaSite.presentation?
              AmoebaSite.presentation = new AmoebaSite.SceneController(@$el, =>
                this._openCurtains(false)
              )
              AmoebaSite.presentation.start()

          when 'done'
            # delay a bit so it's not so fast a transition
            setTimeout( =>
              curtains.tearDown()
            , AmoebaSite.utils.dur(1000))
      )
    else
      curtains = new AmoebaSite.Curtains($("body"), true, (step) =>
        switch step
          when '1'
            # switch to home page
            Backbone.history.navigate("/", trigger: true);

          when 'done'
            curtains.tearDown()
      )

