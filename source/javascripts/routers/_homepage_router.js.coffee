class AmoebaSite.HomepageRouter extends Amoeba.Router
  initialize: (options) ->
    @homepageView = @render 'Homepage'
    @presentationView = @render 'Presentation'

    @route "", "home", ->
      @homepageView.transition('home')
    @route /team(.*)/, "team", ->
      @homepageView.transition('team')
    @route /contactus(.*)/, "contactus", ->
      @homepageView.transition('contactus')


    $("body").on("switchToPresentation", (event) =>
      @homepageView.hideView()
      @presentationView.showView()
    )

