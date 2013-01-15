#= require jquery-1.8.2
#= require jquery.transit
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
    this.get '/team*splat', (req) ->
      Amoeba.homepageView.showTeam()
    this.get '/contactus*splat', (req) ->
      Amoeba.homepageView.showContact()
    this.post '/contactus/submit', (req) ->
      Amoeba.homepageView.submitForm(req)

  Amoeba.App.start()