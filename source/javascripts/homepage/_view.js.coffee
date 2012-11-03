window.Amoeba ?= {}

class Amoeba.HomepageView
  constructor: ->
    this.cacheElements()
    this.bindEvents()

  cacheElements: ->
    @$header = $("#header")
    @$logoNav = $("#logo nav")
    @$document = $(document)

  bindEvents: ->
    $(".contactus-button").on 'click', ->
      STH.showContact()
      return false

    $(".team-button").on 'click', ->
      STH.showTeam()
      return false

    # Slide in Header when scrolled down far enough
    @$document.on 'scroll.header', =>
      if @$document.scrollTop() < @$logoNav.offset().top
        @$header.slideUp()
      else @$header.slideDown()
