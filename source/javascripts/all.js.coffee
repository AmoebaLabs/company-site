#= require jquery-1.8.2
#= require state-machine-2.2.0
#= require davis
#= require_self
#= require_tree .

window.Amoeba ?= {}

jQuery ($) ->
  Amoeba.homepageView = new Amoeba.HomepageView

  Amoeba.App = Davis ->
    this.configure ->
      this.generateRequestOnPageLoad = true
    this.get '/', (req) ->
      Amoeba.homepageView.showHome()
    this.get '/team', (req) ->
      Amoeba.homepageView.showTeam()
    this.get '/contactus', (req) ->
      Amoeba.homepageView.showContact()

  Amoeba.App.start()