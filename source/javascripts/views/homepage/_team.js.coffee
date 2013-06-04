class AmoebaSite.Views.Homepage.Team extends Amoeba.View
  name: 'team'
  el: '#team'

  initialize: ->

  transitionIn: (from) ->
    # When from is 'none' this is an initial page load, so animate instantly
    animationTime = if from is 'none' then 0 else @parent.animationTime

    # Scroll to top if we're animating (not an initial page load)
    @helpers.scrollToTop(animationTime) if animationTime > 0

    @parent.mascot.hide(animationTime)

    # Show team, after a delay
    @$el.css
      opacity: 0
      y: '90px'
    @$el.removeClass("hidden")
    @$el.transition
      opacity: 1
      y: '0px'
      delay: animationTime
      duration: animationTime
      easing: 'ease'

    # Move footer
    $('#footer').fadeOut animationTime, =>
      $('#footer').addClass("team").appendTo("#team").show()

  transitionOut: (to) ->
    animationTime = @parent.animationTime

    # Move footer
    $('#footer').hide().removeClass("team").appendTo("#homepage").fadeIn(animationTime)

    # Hide team
    @$el.disolveOut(animationTime)