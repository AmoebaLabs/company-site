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
        curtains = new AmoebaSite.Curtains($("body"), false, (step) =>
          switch step
            when '2'
              @homepageView.hideView()
            when 'done'
              # delay a bit so it's not so fast a transition
              setTimeout( =>
                @presentationView.showView()
                curtains.tearDown()
              , AmoebaSite.utils.dur(1000))
        )
      else
        curtains = new AmoebaSite.Curtains($("body"), true, (step) =>
          switch step
            when '1'
              @presentationView.hideView()
              @homepageView.showView()
            when 'done'
              curtains.tearDown()
        )
    )

