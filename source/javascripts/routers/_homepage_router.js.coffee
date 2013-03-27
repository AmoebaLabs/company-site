class AmoebaSite.HomepageRouter extends Amoeba.Router
  initialize: (options) ->
    @homepageView = @render 'Homepage'
    @presentationView = @render 'Presentation'

    @route "", "home", ->
      @homepageView.transition('home')
      this._updateViewState(true)
    @route /team(.*)/, "team", ->
      @homepageView.transition('team')
      this._updateViewState(true)
    @route /contactus(.*)/, "contactus", ->
      @homepageView.transition('contactus')
      this._updateViewState(true)

    # presentation routes
    @route(/^presentation\/?$/, "presentation", () =>
      this._showPresentationSlide(0)
    )

    @route("presentation/:id", "presentationStep", (theID) =>
      this._showPresentationSlide(theID)
    )

  _showPresentationSlide: (theSlideID) =>
      this._updateViewState(false)

      # displayIndexEventName is only called here, any other code should use AmoebaSB.eventHelper.indexEventName
      # AmoebaSB.eventHelper.indexEventName will call router navigate and we end up here
      AmoebaSB.eventHelper.triggerEvent(document, "displayIndexEventName", theSlideID)

  _updateViewState: (homePage=true) =>
    if homePage
      @presentationView.hideView()
      @homepageView.showView()
    else
      @presentationView.showView()
      @homepageView.hideView()

