
class AmoebaSite.Presentation.Slide_Cards extends AmoebaSB.Slide_Base
  setup: ->
    this._setupElement("cardsSlide")
    @transition = 'up'
    @cards = []

    this._initializeCards()

    bottomOffet = 10
    leftOffset = 0

    theDiv = $('<div/>')
      .text("\"Los Amoebos\"")
      .appendTo(@el)
      .css({"bottom": "#{bottomOffet}px", "left": "#{leftOffset}px", "position": "absolute", "font-size": "72px"})

  slideIn: (afterTransitionComplete) =>
    if afterTransitionComplete
      # delay a bit and then show stuff
      setTimeout =>
        this._showCards()
      , 200

  slideOut: (afterTransitionComplete) =>
    if afterTransitionComplete
      this._resetCards()

  _showCards: () =>
    theCards = @el.find(".businessCard")

    countDown = theCards.length

    _.each(theCards, (element, theIndex) =>
      theCard = $(element)
      theCSS = _.extend({ delay: theIndex*50 }, {x: 0, y: 0})
      theCard.transition(theCSS, =>
        theCard.keyframe('bounceIn', 800, 'ease-out', 0, 1, 'normal', () =>
          theCard.css(AmoebaSB.keyframeAnimationPlugin.animationProperty, '')

          countDown--
          if countDown == 0
            this._slideIsDone(1000)
        )
      )
    )

  _cardCSSObject: (index) =>
    rotate = 0
    top = 20*index
    left = 100*index
    scale = 0

    result =
      perspective: '1000px'
      rotate: rotate
      top: top
      left: left
      duration: 500
      easing: 'snap'
      x: '50%'
      y: 2000

    return result

  _createCard: (theIndex) =>
    theName = "wtf?"
    switch theIndex
      when 0
        theName = "Daniel Jabbour"
        imgName = "daniel"
      when 1
        theName = "Steve Gehrman"
        imgName = "steve"
      when 2
        theName = "Richard Enlow"
        imgName = "richard"
      when 3
        theName = "Chris Chiles"
        imgName = "chrisc"
      when 4
        theName = "Chris Barton"
        imgName = "chrisb"
      when 5
        theName = "Ohia the Dog"
        imgName = "ohia"

    theCard = $('<div/>')
      .addClass("businessCard")
      .css(this._cardCSSObject(theIndex))
      .appendTo(@el)

    theImage = $('<img/>')
      .attr({src: "/images/team/#{imgName}.png"})
      .appendTo(theCard)

    theText = $('<span/>')
      .text(theName)
      .appendTo(theCard)

    return theCard

  _initializeCards: =>
    _.each([0..5], (index) =>
      @cards.push(this._createCard(index))
    )

  _resetCards: =>
    _.each(@cards, (card, index) =>
      card.css(this._cardCSSObject(index))
    )
