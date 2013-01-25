class AmoebaSite.Views.Homepage.Home extends Amoeba.View
  name: 'home'
  el: '#homepage'

  initialize: ->
    @$('.capability-box').hover (e) ->
      $(this).find('.rollover').fadeOut(@parent.animationTime)
    ,(e) ->
      $(this).find('.rollover').fadeIn(@parent.animationTime)

    @parent.on('hideCapabilities:home', @hideCapabilities)
    @parent.on('showCapabilities:home', @showCapabilities)

  transitionIn: (from) ->
    # When from is 'none' this is an initial page load, so animate instantly
    animationTime = if from is 'none' then 0 else @parent.animationTime

    @parent.hideHeader(animationTime) # Coming from contactus, get rid of header
    @helpers.scrollToTop(animationTime)
    @showCapabilities(animationTime)
    @parent.showFooter()
    @parent.mascot.show(animationTime)

    @showLogo()

  transitionOut: (to) ->
    # Stub

  showCapabilities: (animationTime = 0) ->
    $.each ["#logo", ".capabilities"], (index, klass) =>
      @$(klass).disolveIn(animationTime)

  hideCapabilities: (animationTime = 0) ->
    $.each ["#logo", ".capabilities"], (index, klass) =>
      @$(klass).disolveOut(animationTime)

  showLogo: (animationTime = 0) ->
    @$("#logo").disolveIn(animationTime)

