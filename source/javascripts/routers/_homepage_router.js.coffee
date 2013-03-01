class AmoebaSite.HomepageRouter extends Amoeba.Router
  initialize: (options) ->
    @homepageView = @render 'Homepage'

    @route "", "home", ->
      @homepageView.transition('home')
    @route /team(.*)/, "team", ->
      @homepageView.transition('team')
    @route /contactus(.*)/, "contactus", ->
      @homepageView.transition('contactus')

    # presentation routes
    @route(/^presentation\/?$/, "presentation", () =>
      this._showPresentationSlide(0)
    )

    @route("presentation/:id", "presentationStep", (theID) =>
      this._showPresentationSlide(theID)
    )

  _showPresentationSlide: (theSlideID) =>
      @homepageView.transition('presentation')

      # displayIndexEventName is only called here, any other code should use navigateToIndexEventName
      # navigateToIndexEventName will call router navigate and we end up here
      AmoebaSB.eventHelper.triggerEvent(document, "displayIndexEventName", theSlideID)
