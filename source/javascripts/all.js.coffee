#= require jquery-1.8.2
#= require state-machine-2.2.0
#= require_self
#= require_tree .

window.Amoeba ?= {}

jQuery ($) ->
  Amoeba.homepageView = new Amoeba.HomepageView