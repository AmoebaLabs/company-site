class AmoebaSite.Views.Homepage.Mascot extends Amoeba.View
  name: 'home'
  el: '#mascot'
  events:
    'click img': 'mascotClick'

  show: (animationTime = 0) ->
    @$el.disolveIn(animationTime)

  hide: (animationTime = 0) ->
    @$el.disolveOut(animationTime, => @$el.removeClass("contactus"))

  shrink: (animationTime = 0) ->
    if (animationTime > 0)
      @$el.addClassWithTransition
        className: "contactus"
        duration: animationTime
    else
      @$el.addClass("contactus")

  grow: (animationTime = 0) ->
    if (animationTime > 0)
      @$el.removeClassWithTransition
        className: "contactus",
        duration: animationTime
    else
      @$el.removeClass("contactus")

  mascotClick: ->
    $("body").trigger("switchToPresentation")
