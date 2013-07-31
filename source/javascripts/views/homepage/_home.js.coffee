class AmoebaSite.Views.Homepage.Home extends Amoeba.View
  name: 'home'
  el: '#homepage'

  transitionIn: (from) ->
    # When from is 'none' this is an initial page load, so animate instantly
    animationTime = if from is 'none' then 0 else @parent.animationTime

    @helpers.scrollToTop(animationTime)
    @_showTicker(animationTime)
    @parent.showFooter(animationTime)
    @parent.mascot.show(animationTime)
    @_showLogo(animationTime)

  transitionOut: (to) ->
    animationTime = @parent.animationTime

    # hack that will be removed when refactored
    if @parent.mobileMode
      animationTime = 0

    @_hideTicker(animationTime)
    @_hideLogo(animationTime)

  _showTicker: (animationTime = 0) ->
    @$("#ticker").disolveIn(animationTime)

  _hideTicker: (animationTime = 0) ->
    @$("#ticker").disolveOut(animationTime)

  _showLogo: (animationTime) ->
    @$("#logo").disolveIn(animationTime, @parent.callbackHelper.callback())

  _hideLogo: (animationTime) ->
    @$("#logo").disolveOut(animationTime)