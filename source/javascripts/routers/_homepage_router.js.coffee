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
          @homepageView.hideView()
          @presentationView.showView()
          # delay a bit so it's not so fast a transition
          setTimeout( =>
            curtains.tearDown()
          , 1000)
        )
      else
        @presentationView.hideView()

        curtains = new AmoebaSite.Curtains($("body"), true, =>
          @homepageView.showView()
          curtains.tearDown()
        )
    )

