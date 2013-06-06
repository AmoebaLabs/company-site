class AmoebaSite.Views.Homepage.Header extends Amoeba.View
  el: '#header'
  events:
    'click #mobile-button': '_toggleMobileNav'

  initialize: ->
    # disabled the close on click behaviour, I think making the user toggle it manually is better
    # this._setupMobileNavClickHandler()

    @mobileMode = false
    enquire.register("screen and (max-width: 760px)",   # see _util.css.scss - this is mobile
      match: =>
        this._updateForMobile(true)
      ,
      unmatch: =>
        this._updateForMobile(false)
    )

  _toggleMobileNav: ->
    $("#mobile-nav").slideToggle(@parent.animationTime)

  adjustHeader: () =>
    # header always shows the header
    if @mobileMode
      this._showHeader()
    else
      # make sure the mobile nav is hidden when not mobile. show the nav in mobile then resize window size to see it disappear
      $("#mobile-nav").hide()

      switch @parent.currentPageName()
        when 'home', 'none'   # hides the header on home screen, show otherwise
          this._hideHeader()
        else
          this._showHeader()

  _showHeader: (animationTime = 0) ->
    $("#header").slideDown(animationTime)

  _hideHeader: (animationTime = 0) ->
    $("#header").slideUp(animationTime)

  _updateForMobile: (mobile) ->
    @mobileMode = mobile

    this.adjustHeader()

  _setupMobileNavClickHandler: () ->
    # closes menu on click
    $(".mobile-nav-button").click (e) ->
      $("#mobile-nav").hide()

