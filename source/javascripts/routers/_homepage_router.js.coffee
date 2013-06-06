class AmoebaSite.HomepageRouter extends Amoeba.Router
  initialize: (options) ->
    this.setupViews()

    @route "", "home", ->
      @homepageView.transition('home')
    @route /team(.*)/, "team", ->
      @homepageView.transition('team')
    @route /contactus(.*)/, "contactus", ->
      @homepageView.transition('contactus')

  setupViews: ->
    @homepageView = @render 'Homepage'
    @presentationView = @render 'Presentation'

    $("body").on("switchToPresentation", (event, presentation) =>
      if presentation
        curtains = new AmoebaSite.Curtains($("body"), false, =>
          curtains.tearDown()

          @homepageView.hideView()
          @presentationView.showView()
        )
      else
        curtains = new AmoebaSite.Curtains($("body"), true, =>
          curtains.tearDown()

          @homepageView.showView()
          @presentationView.hideView()
        )
    )

