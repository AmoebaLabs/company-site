class AmoebaSite.Views.Homepage.Home extends Amoeba.View
  name: 'home'
  el: '#homepage'

  initialize: ->
    @$('.capability-box').hover (e) =>
      $(this).find('.rollover').fadeOut(@parent.animationTime)
    ,(e) =>
      $(this).find('.rollover').fadeIn(@parent.animationTime)

  transitionIn: (from) ->
    # When from is 'none' this is an initial page load, so animate instantly
    animationTime = if from is 'none' then 0 else @parent.animationTime

    @helpers.scrollToTop(animationTime)
    @_showCapabilities(animationTime)
    @parent.showFooter(animationTime)
    @parent.mascot.show(animationTime)
    @_showLogo(animationTime)

  transitionOut: (to) ->
    animationTime = @parent.animationTime

    @_hideCapabilities(animationTime)
    @_hideLogo(animationTime)

  _showCapabilities: (animationTime = 0) ->
    @$(".capabilities").disolveIn(animationTime)

  _hideCapabilities: (animationTime = 0) ->
    @$(".capabilities").disolveOut(animationTime)

  _showLogo: (animationTime) ->
    @$("#logo").disolveIn(animationTime, @parent.callbackHelper.callback())

  _hideLogo: (animationTime) ->
    @$("#logo").disolveOut(animationTime)
