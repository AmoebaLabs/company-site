class AmoebaSite.Views.Homepage.Header extends Amoeba.View
  animationTime: 1000
  el: '#header'
  events:
    'click #mobile-button': '_toggleMobileNav'

  initialize: ->
    @mobileMode = false
    enquire.register("screen and (max-width: 760px)",   # see _util.css.scss - this is mobile
      match: =>
        this._updateForMobile(true)
      ,
      unmatch: =>
        this._updateForMobile(false)
    )

  _toggleMobileNav: ->
    $("#mobile-nav").slideToggle(@animationTime)

  adjustHeader: () =>
    # header always shows the header
    if @mobileMode
      this._showHeader()
    else
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
