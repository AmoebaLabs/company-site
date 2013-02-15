#= require_self
#= require_directory ./homepage

class AmoebaSite.Views.Homepage extends Amoeba.View
  events: 'click #mobile-button': 'toggleMobileNav'
  animationTime: 1000
  el: '#homepage'

  initialize: ->
    @subViews =
      home: @_render 'Homepage.Home'
      contactus: @_render 'Homepage.Contactus'
      team: @_render 'Homepage.Team'

    @mascot = @_render 'Homepage.Mascot'

  transition: (to) ->
    return if @currentSubView and @currentSubView.name is to

    @currentSubView?.transitionOut?(to)

    from = if @currentSubView then @currentSubView.name else 'none'
    @currentSubView = @subViews[to]
    @currentSubView.transitionIn?(from)

  toggleMobileNav: ->
    $("#mobile-nav").slideToggle(@animationTime)

  showHeader: (animationTime = 0) ->
    $("#header").slideDown(animationTime)

  hideHeader: (animationTime = 0) ->
    $("#header").slideUp(animationTime)

  showFooter: (animationTime = 0) ->
    $("#footer").disolveIn(animationTime)

  hideFooter: (animationTime = 0) ->
    $("#footer").disolveOut(animationTime)