class AmoebaSite.Views.Homepage.Home extends Amoeba.View
  name: 'home'
  el: '#homepage'

  initialize: ->
    @$('.capability-box').hover (e) =>
      $(this).find('.rollover').fadeOut(@parent.animationTime)
    ,(e) =>
      $(this).find('.rollover').fadeIn(@parent.animationTime)

    @parent.on('hideCapabilities:home', @hideCapabilities)
    @parent.on('showCapabilities:home', @showCapabilities)

  transitionIn: (from) ->
    # When from is 'none' this is an initial page load, so animate instantly
    animationTime = if from is 'none' then 0 else @parent.animationTime

    @parent.header.hideHeader(animationTime) # Coming from contactus, get rid of header
    @helpers.scrollToTop(animationTime)
    @showCapabilities(animationTime)
    @parent.showFooter(animationTime)
    @parent.mascot.show(animationTime)
    @showLogo(animationTime)

  transitionOut: (to) ->
    animationTime = @parent.animationTime

    @hideCapabilities(animationTime)
    @hideLogo(animationTime)

  showCapabilities: (animationTime = 0) ->
    @$(".capabilities").disolveIn(animationTime)

  hideCapabilities: (animationTime = 0) ->
    @$(".capabilities").disolveOut(animationTime)

  showLogo: (animationTime = 0) ->
    @$("#logo").disolveIn(animationTime)

  hideLogo: (animationTime = 0) ->
    @$("#logo").disolveOut(animationTime)
