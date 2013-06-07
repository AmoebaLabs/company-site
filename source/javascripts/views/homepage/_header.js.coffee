class AmoebaSite.Views.Homepage.Header extends Amoeba.View
  el: '#header'
  events:
    'click #mobile-button': '_toggleMobileNav'

  initialize: ->
    this._setupMobileNavClickHandler()

    @mobileMode = false
    enquire.register("screen and (max-width: 760px)",   # see _util.css.scss - this is mobile
      match: =>
        this._updateForMobile(true)
      ,
      unmatch: =>
        this._updateForMobile(false)
    )

  _toggleMobileNav: ->
   this._css3SlideToggle($("#mobile-nav"))

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
    $(".mobile-nav-button").click (e) =>
      this._css3SlideToggle($("#mobile-nav"))

    $("#header a").click (e) =>
      this._css3SlideUp($("#mobile-nav"))

  _css3SlideToggle: (jqueryObject) =>
    if jqueryObject.css('display') == "none"
      this._css3SlideDown(jqueryObject)
    else
      this._css3SlideUp(jqueryObject)

  _css3SlideUp: (jqueryObject) =>
    if jqueryObject.css('display') != "none"
      duration = @parent.animationTime * .7  # make it faster than the standard time

      jqueryObject.transition(
        duration: duration
        height: 0
        easing: 'ease'
        complete: =>
          jqueryObject.css(
            display: 'none'
          )
      )

  _css3SlideDown: (jqueryObject) =>
    duration = @parent.animationTime * .7  # make it faster than the standard time

    # save/read the original height
    heightKey = 'saved-height'
    savedHeight = jqueryObject.data(heightKey)
    if not savedHeight?
      savedHeight = jqueryObject.height()
      jqueryObject.data(heightKey, savedHeight)

    if jqueryObject.css('display') == "none"
      jqueryObject.css(
        display: 'block'
        height: 0
        overflow: 'hidden'
      )

      jqueryObject.transition(
        duration: duration
        height: savedHeight
        easing: 'ease'
      )

