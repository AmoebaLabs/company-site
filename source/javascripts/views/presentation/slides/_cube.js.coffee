
class AmoebaSite.Presentation.Slide_Cube extends AmoebaSB.Slide_Base
  setup: ->
    this._setupElement("cubeSlide")
    this._initializeVariables()

    this._setupCube()

    this._transformToCube()

    @numSteps = 6
    @transition = 'previous'

    tweakXDeg = -15
    tweakYDeg = -15

    @rotationSteps = []
    @rotationSteps[0] =
      x:0 + tweakXDeg
      y:0 + tweakYDeg
      z:0
    @rotationSteps[1] =
      x:0 + tweakXDeg
      y:-90 + tweakYDeg
      z:0
    @rotationSteps[2] =
      x:0 + tweakXDeg
      y:-90 + tweakYDeg
      z:90
    @rotationSteps[3] =
      x:0 + tweakXDeg
      y:-180 + tweakYDeg
      z:90
    @rotationSteps[4] =
      x:-90 + tweakXDeg
      y:-180 + tweakYDeg
      z:90
    @rotationSteps[5] =
      x:-90 + tweakXDeg
      y:-180 + tweakYDeg
      z:180

  _update: =>
    if (@stepIndex >= 0)
      r = @rotationSteps[@stepIndex]

      $("#threeDCube").transition(
        rotateX: r.x
        rotateY: r.y
        rotate: r.z
        duration: 400
      )

  _setupCube: =>
    stage = $('<div/>')
      .appendTo(@el)
      .attr("id", "threeDCubeStage")
      .css(AmoebaSB.layout.center(@cubeSize, @cubeSize))

    cube = $('<div/>')
      .appendTo(stage)
      .attr("id", "threeDCube")

    sentences = [
      "1. IDEA"
      "2. BALANCE"
      "3. INVOLVEMENT STAKEHOLDERS AND USERS"
      "4. VALIDATE ASSUMPTIONS"
      "5. AGILE PRODUCTION FEEDBACK TESTING DEVELOPMENT"
      "6. PRODUCT"
    ]

    _.each(sentences, (text, index) =>
      @cubeFaces.push(
        $('<div/>')
          .appendTo(cube)
          .text(text)
          .css(@flatTransforms[index])
      )
    )

  _cubeTransform: (x, y, z, pop=0, spin=0) =>
    x += spin
    y += spin
    z += spin

    result =
      transform: "rotateY(#{y}deg) rotateX(#{x}deg) rotateZ(#{z}deg) translateZ(#{(@cubeSize / 2) + pop}px)"

    return result

  _flatTransform: (theIndex) =>
    result =
      transform: "translateY(#{theIndex*-34}px) translateX(#{theIndex*63}px)"

    return result

  _transformToCube: () =>
    theDelay = 200
    _.each(@cubeFaces, (face, index) =>
      face.transition({delay: 800})
      face.transition(_.extend({delay: index*theDelay}, @cubeTransforms[index]))
    )

  _initializeVariables: () =>
    @cubeSize = 420
    @cubeFaces = []

    @cubeTransforms = [
      this._cubeTransform(0, 0, 0)
      this._cubeTransform(0, 90, 0)
      this._cubeTransform(90, 90, 0)
      this._cubeTransform(0, 180, 90)
      this._cubeTransform(0, -90, 90)
      this._cubeTransform(-90, 0, 0)
    ]

    pop = 330
    spin = 24
    @popCubeTransforms = [
      this._cubeTransform(0, 0, 0, pop, spin)
      this._cubeTransform(0, 90, 0, pop, spin)
      this._cubeTransform(90, 90, 0, pop, spin)
      this._cubeTransform(0, 180, 90, pop, spin)
      this._cubeTransform(0, -90, 90, pop, spin)
      this._cubeTransform(-90, 0, 0, pop, spin)
    ]

    @flatTransforms = []
    _.each([0..5], (element, index) =>
      @flatTransforms.push(this._flatTransform(index+1))
    )

