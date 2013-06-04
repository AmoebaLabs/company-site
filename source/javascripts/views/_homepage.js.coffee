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
    return if @currentSubView and @currentSubView.name is to

    @currentSubView?.transitionOut?(to)

    from = this.currentPageName()
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