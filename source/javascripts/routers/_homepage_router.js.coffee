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
        @homepageView.hideView()

        curtains = new AmoebaSite.Curtains($("body"), false, =>
          @presentationView.showView()
          curtains.tearDown()
        )
      else
        @presentationView.hideView()

        curtains = new AmoebaSite.Curtains($("body"), true, =>
          @homepageView.showView()
          curtains.tearDown()
        )
    )

