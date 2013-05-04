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
      this._updateViewState(false)
    )

  _updateViewState: (homePage=true) =>
    if homePage
      @presentationView.hideView()
      @homepageView.showView()
    else
      @presentationView.showView()
      @homepageView.hideView()

