
class AmoebaSite.Presentation.CogDemo
  constructor: (divHolder, @size, @numSegments) ->
    @graphicsPaper = new AmoebaSB.GraphicsPaper(divHolder, {fill: "transparent", stroke: "transparent"})
    @animations = []

    cog = new AmoebaSite.Presentation.Cog(@size, @numSegments, @graphicsPaper);
    @pathMap = {
      "cog": cog.path(true),
      "circleCog": cog.path(false),
      "circle4Points": AmoebaSB.Graphics.circleWithFourPoints(0,0,@size/2),
      "rect4Points": AmoebaSB.Graphics.rectWithFourPoints(0,0,200,300),
    }

  start: =>
    this.stop()

    # colors copied from the variables css file. didn't know a simple way of sharing these vars outside of sass
    amoebaColors = ["90-#{AmoebaSite.Colors.amoebaGreen}-#{AmoebaSite.Colors.amoebaGreenDark}",
      "90-#{AmoebaSite.Colors.amoebaGreen}-#{AmoebaSite.Colors.amoebaGreenMedium}",
      "90-#{AmoebaSite.Colors.amoebaGreenMedium}-#{AmoebaSite.Colors.amoebaGreenDark}"]

    _.each([0...3], (i) =>
      @animations.push(new CogAnimation(amoebaColors[i], i, @size, @graphicsPaper, @pathMap))
    )

    one.animate() for one in @animations

  stop: =>
    if @animations?
      one.remove() for one in @animations

    @animations.length = 0

class CogAnimation
  constructor: (@fillColor, @index, @cogSize, graphicsPaper, @pathMap) ->
    @pathSwitch = true
    @removed = false;

    # create it offscreen and transparent
    @mainPath = graphicsPaper.paper.path(this.pathOne()).attr({fill:@fillColor, opacity: 0, transform: "t#{graphicsPaper.width()},0"})

  remove: ->
    @removed = true

    # animate it out so it looks cool
    # Warning: this final animation could get stopped and we never get removed
    @mainPath.animate opacity:0, 400, "<>", =>
      @mainPath.remove()

  animate: ->
    setTimeout( =>
      this._animate()
    , 100*@index)

  _animate: ->
    this._stop()
    @mainPath.animate {opacity: 1, transform: "t0,0"}, 600, "<>", =>
      this.rotate();

  _stop: ->
    # don't stop if removing, we don't want our final animation to get canceled which would prevent the removal of the element
    if (not @removed)
      @mainPath.stop()

  rotate: =>
    start = "r0"
    end = "r360"

    if (@index % 2) == 0
      start = "r360"
      end = "r0"

    @mainPath.animate transform: start, 0, "", =>
      @mainPath.animate transform: end, 6000, "<>", =>
        this.changeToPathTwo()

  changeToPathTwo: =>
    @mainPath.animate path:this.pathTwo(), 800, "<>", =>
      this.changeToPathThree()

  changeToPathThree: =>
    # just changing circles, 0 duration
    @mainPath.animate path:this.pathThree(), 0, "", =>
      this.changeToPathFour()

  changeToPathFour: =>
    @mainPath.animate path:this.pathFour(), 800, "<>", =>
      this.changeToPathFive()

  changeToPathFive: =>

    setTimeout( =>

      bBox = @mainPath.getBBox()
      if (bBox?)  # saw this randomly return undefined once
        diff = 700 - bBox.y2
        @mainPath.animate transform:"t0,#{diff}", 800, "bounce", =>
          console.log("done")

    , 500)

  pathOne: ->
    result = @pathMap["cog"]

    result = AmoebaSB.Graphics.normalizePath(result)

    y = 0
    if (@index % 2) != 0
      y = 200

    result = AmoebaSB.Graphics.translatePath(result, @index*(@cogSize-80), y);

    return result

  pathTwo: ->
    result = @pathMap["circleCog"]

    result = AmoebaSB.Graphics.normalizePath(result)
    result = AmoebaSB.Graphics.scalePath(result, .5, .5)
    result = AmoebaSB.Graphics.translatePath(result, 100+@index*220, 120);

    return result

  pathThree: ->  # 4 part circle step
    result = @pathMap["circle4Points"]

    result = AmoebaSB.Graphics.normalizePath(result)
    result = AmoebaSB.Graphics.scalePath(result, .5, .5)
    result = AmoebaSB.Graphics.translatePath(result, 100+@index*220, 120);

    return result

  pathFour: ->
    result = @pathMap["rect4Points"]

    result = AmoebaSB.Graphics.normalizePath(result)

    result = AmoebaSB.Graphics.scalePath(result, .5, .5 + .3*(3-@index));
    result = AmoebaSB.Graphics.translatePath(result, 500+(@index*120), 220);

    return result







