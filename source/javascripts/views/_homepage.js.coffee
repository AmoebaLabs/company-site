#= require_self
#= require_directory ./homepage

class AmoebaSite.Views.Homepage extends Amoeba.View
  animationTime: 1000
  el: '#homepage'

  initialize: ->
    @callbackHelper = new AmoebaSite.Helpers.transitionCallbackHelper(this._transitionCompleteCallback)

    @subViews =
      home: @_render 'Homepage.Home'
      contactus: @_render 'Homepage.Contactus'
      team: @_render 'Homepage.Team'

    @mascot = @_render 'Homepage.Mascot'
    @header = @_render 'Homepage.Header'

  transition: (to) ->
    # don't do anything if busy
    if @callbackHelper.busy()
      @delayedTransitionToValue = to
      return

    from = this.currentPageName()
    return if from == to

    @currentSubView?.transitionOut?(to)

    @currentSubView = @subViews[to]
    @currentSubView.transitionIn?(from)

    # show or hide header depending on state
    @header.adjustHeader()

  currentPageName: ->
    return if @currentSubView then @currentSubView.name else 'none'

  showFooter: (animationTime = 0) ->
    $("#footer").disolveIn(animationTime)

  hideFooter: (animationTime = 0) ->
    $("#footer").disolveOut(animationTime)

  _transitionCompleteCallback: () =>
    if @delayedTransitionToValue
      delayedTo = @delayedTransitionToValue
      @delayedTransitionToValue = null

      this.transition(delayedTo)
