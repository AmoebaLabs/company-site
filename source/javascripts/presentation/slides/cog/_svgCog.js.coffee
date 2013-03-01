
# ------------------------------------------------
class Amoeba.Presentation.Cog
  constructor: (@size, @numSegments, @graphicsPaper) ->

  path: (showTeeth) ->
    segments = this._createCogSegments(@size, showTeeth, @numSegments)

    result = undefined
    _.each(segments, (segment) =>
      if (not result?)
        result = "M#{segment.bottomLeft.x},#{segment.bottomLeft.y}"

      result += segment.path()
    )

    result += "z"

    return result

  showPoints: =>
    segments = this._createCogSegments(@size, true, @numSegments)

    _.each(segments, (segment) =>
      segment.debugPoints(@graphicsPaper)
    )

  _pointsAroundCircle: (size, inset, numSegments, shift=0) =>
    centerPoint = new AmoebaSB.Point(size/2, size/2)
    radius = (size-(inset*2))/2

    degrees = (360/numSegments)

    result = []

    # .. (not ...) to go one more to add point back to beginning
    _.each([0..numSegments], (i) =>
      angle = i * degrees

      degreesShift = degrees * 0.15
      if shift is -1
        angle -= degreesShift
      else if shift is 1
        angle += degreesShift

      if angle >= 360
        angle = angle - 360
      else if angle < 0
        angle = 360 + angle

      result.push(AmoebaSB.Graphics.pointForAngle(angle, radius, centerPoint))
    )

    return result

  _pairsAroundCircle: (size, inset, numSegments, shifted=false) =>
    result = []

    if (not shifted)
      points = this._pointsAroundCircle(size, inset, numSegments)

      # create a pair of points and add to result
      prevPoint = undefined
      _.each(points, (nextPoint) =>
        if (prevPoint?)
          result.push(new AmoebaSB.Pair(prevPoint, nextPoint))
        prevPoint = nextPoint
      )
    else
      leftPoints = this._pointsAroundCircle(size, inset, numSegments, -1)
      rightPoints = this._pointsAroundCircle(size, inset, numSegments, -1)

      _.each([0...leftPoints.length-1], (i) =>
        result.push(new AmoebaSB.Pair(leftPoints[i], rightPoints[i+1]))
      )

    return result

  _createCogSegments: (size, showTeeth, numSegments) =>
    result = []
    toothHeight = 0

    outerPoints = this._pairsAroundCircle(size, 0, numSegments, false)

    # calc tooth height relative to distance between outer points
    if (showTeeth)
      toothHeight = outerPoints[0].left.distance(outerPoints[0].right) * 0.55

    innerPoints = this._pairsAroundCircle(size, toothHeight, numSegments, false)

    if ((outerPoints.length != innerPoints.length) or (outerPoints.length != numSegments))
      console.log("inner and outer points not right?")
    else
      isTooth = false

      _.each([0...numSegments], (i) =>
        outerPoint = outerPoints[i]
        innerPoint = innerPoints[i]

        newSegment = new CogSegment(isTooth, size, toothHeight, outerPoint.left, outerPoint.right, innerPoint.left, innerPoint.right);
        result.push(newSegment)

        isTooth = not isTooth
      )

    return result;

class CogSegment
  constructor: (@isTooth, @size, @toothHeight, @topLeft, @topRight, @bottomLeft, @bottomRight) ->
    @outerRadius = @size/2
    @innerRadius = (@size - (@toothHeight * 2)) / 2

  toString: ->
    return "(#{@topLeft}, #{@topRight}, #{@bottomLeft}, #{@bottomRight})"

  debugPoints: (graphicsPaper) ->
    if @isTooth
      graphicsPaper.addPoints([@topLeft], 2, "black")
      graphicsPaper.addPoints([@topRight], 2, "orange")
      graphicsPaper.addPoints([@bottomLeft], 2, "black")
      graphicsPaper.addPoints([@bottomRight], 2, "orange")
    else
      graphicsPaper.addPoints([@topLeft], 2, "red")
      graphicsPaper.addPoints([@topRight], 2, "yellow")
      graphicsPaper.addPoints([@bottomLeft], 2, "red")
      graphicsPaper.addPoints([@bottomRight], 2, "yellow")

  path: ->
    result = ""

    if @isTooth
      result += "L#{@topLeft.x},#{@topLeft.y}"
      result += "A#{@outerRadius},#{@outerRadius},0,0,1,#{@topRight.x},#{@topRight.y}"
      result += "L#{@bottomRight.x},#{@bottomRight.y}"
    else
      flag = 1
      if @toothHeight > 0
        flag = 0

      result += "A#{@outerRadius},#{@outerRadius},0,0,#{flag},#{@bottomRight.x},#{@bottomRight.y}"

    return result;




