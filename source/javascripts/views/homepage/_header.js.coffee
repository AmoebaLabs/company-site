class AmoebaSite.Views.Homepage.Header extends Amoeba.View
  animationTime: 1000
  name: 'header'
  el: '#header'

  events:
    'click #mobile-button': 'toggleMobileNav'

  initialize: ->

  toggleMobileNav: ->
    $("#mobile-nav").slideToggle(@animationTime)

  showHeader: (animationTime = 0) ->
    $("#header").slideDown(animationTime)

  hideHeader: (animationTime = 0) ->
    $("#header").slideUp(animationTime)

