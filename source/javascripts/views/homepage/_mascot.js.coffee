class AmoebaSite.Views.Homepage.Mascot extends Amoeba.View
  name: 'home'
  el: '#mascot'
  events:
    'click img': 'mascotClick'

  show: (animationTime = 0) ->
    @$el.disolveIn(animationTime)

  hide: (animationTime = 0) ->
    @$el.disolveOut(animationTime, => this._removeClasses())

  shrink: (animationTime = 0) ->
    this.show(animationTime)  # make sure it's shown, on a refresh just calling center wasn't showing it
    this._removeClasses()

    if (animationTime > 0)
      @$el.addClassWithTransition
        className: "contactus"
        duration: animationTime
    else
      @$el.addClass("contactus")

  center: (animationTime = 0) ->
    this.show(animationTime)  # make sure it's shown, on a refresh just calling center wasn't showing it
    this._removeClasses()

    if (animationTime > 0)
      @$el.addClassWithTransition
        className: "presentation"
        duration: animationTime
    else
      @$el.addClass("presentation")

  grow: (animationTime = 0) ->
    this.show(animationTime)  # make sure it's shown, on a refresh just calling center wasn't showing it

    if (animationTime > 0)
      @$el.removeClassWithTransition
        className: "contactus",
        duration: animationTime
    else
      this._removeClasses()

  _removeClasses: =>
    @$el.removeClass("contactus presentation")

  mascotClick: (e) ->
    Backbone.history.navigate("presentation", trigger: true)

    # normally set to go to the home page, but we are hijacking it, we could fix this later once finalized
    e.preventDefault()
    e.stopPropagation()