class AmoebaSite.App extends Amoeba.App
  initialize: ->
    @homepageRouter = new AmoebaSite.HomepageRouter()

jQuery ($) ->
  AmoebaSite.app = AmoebaSite.App.start
    pushState: true
    viewPath: AmoebaSite.Views