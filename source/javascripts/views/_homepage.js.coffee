#= require_self
#= require_directory ./homepage

class AmoebaSite.Views.Homepage extends Amoeba.View
  animationTime: 1000
  el: '#homepage'

  initialize: ->
    @subViews =
      home: @_render 'Homepage.Home'
      contactus: @_render 'Homepage.Contactus'
      team: @_render 'Homepage.Team'

    @mascot = @_render 'Homepage.Mascot'
    @header = @_render 'Homepage.Header'

  transition: (to) ->
    # to avoid problems of clicking too fast on header buttons there is a check to make sure they are spaced by a second
    if @justClicked
      @delayedTransitionToValue = to
    else
      @justClicked = true
      this._transition(to)

      setTimeout(=>
        @justClicked = false

        if @delayedTransitionToValue
          delayedTo = @delayedTransitionToValue
          @delayedTransitionToValue = null

          this.transition(delayedTo)
      , 2000)

  currentPageName: ->
    return if @currentSubView then @currentSubView.name else 'none'

  showFooter: (animationTime = 0) ->
    $("#footer").disolveIn(animationTime)

  hideFooter: (animationTime = 0) ->
    $("#footer").disolveOut(animationTime)

  _transition: (to) ->
    from = this.currentPageName()
    return if from == to

    @currentSubView?.transitionOut?(to)

    @currentSubView = @subViews[to]
    @currentSubView.transitionIn?(from)

    # show or hide header depending on state
    @header.adjustHeader()
