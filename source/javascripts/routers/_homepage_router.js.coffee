class AmoebaSite.HomepageRouter extends Amoeba.Router
  initialize: (options) ->
    @homepageView = @render 'Homepage'

    @route "", "home", ->
      @homepageView.transition('home')
    @route /team(.*)/, "team", ->
      @homepageView.transition('team')
    @route /contactus(.*)/, "contactus", ->
      @homepageView.transition('contactus')
    @route /presentation(.*)/, "presentation", ->
      @homepageView.transition('presentation')

