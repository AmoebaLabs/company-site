class AmoebaSite.Cloud
  constructor:(parentDiv, computedWeights, fps, fluffy=false) ->
    @fluffControl = if fluffy then 0.8 else 0.4

    this._createCloudBase(parentDiv);
    this._createCloudLayers(computedWeights, fps)

  transformLayers: (angleX, angleY) =>
    _.each(@layers, (layer, index) =>
      updatedA = layer.data('a') + layer.data('speed')
      layer.data('a', updatedA)
      t = "translateX(#{layer.data('x')}px) translateY(#{layer.data('y')}px) translateZ(#{layer.data('z')}px) rotateY(#{(-angleY)}deg) rotateX(#{(-angleX)}deg) rotateZ(#{layer.data('a')}deg) scale(#{layer.data('s')})"

      layer.css(transform: t)
    )

  applyCSS: (css) =>
    @cloudBase.css(css)

  animateCSS: (css, hideTransition) =>
    @cloudBase.transition(css)
    if hideTransition?
      @cloudBase.transition(hideTransition)

  applyCSSToLayers: (animate, css) =>
    _.each(@layers, (layer, index) =>
      if animate
        layer.css(css)
      else
        layer.transition(css)
    )

  # need the closure on layer, so made it a function
  _loadLayer: (layer) =>
    layer.load( () =>
      # sets opacity after the image is loaded to fade in
      duration = Math.random() * 1500
      opacity = 0.4 + (Math.random() * 0.5)
      layer.transition(
        opacity: opacity
        duration: duration
        easing: 'out'
      )
    )

  _createCloudBase:(parentDiv) =>
    @cloudBase = $("<div/>")
      .addClass("cloudBase")

    @cloudBase.appendTo(parentDiv)

    x = 256 - (Math.random() * 512)
    y = 256 - (Math.random() * 512)
    z = 256 - (Math.random() * 512)
    t = "translateX(#{x}px) translateY(#{y}px) translateZ(#{z}px)"
    @cloudBase.css(transform: t)

  _createCloudLayers: (computedWeights, fps) =>
    @layers = []

    cnt = 5 + Math.round(Math.random() * 10)
    for j in [0...cnt]
      layer = $("<img/>")
      layer.css(opacity: 0)
      r = Math.random()
      src = "troll.png"     # SNG need this image, or fix code

      _.each(computedWeights, (weight, index) =>
        if r >= weight.min and r <= weight.max
          # sets load handler so we fade in after the image is loaded, not before
          this._loadLayer(layer)
          src = weight.src
      )

      layer.attr(src: src)
      layer.addClass("cloudLayer")

      x = 256 - (Math.random() * 512)
      y = 256 - (Math.random() * 512)
      z = 100 - (Math.random() * 200)
      a = Math.random() * 360
      s = .25 + Math.random()
      x *= @fluffControl
      y *= @fluffControl

      data =
        x: x
        y: y
        z: z
        a: a
        s: s
        speed: ((60/Math.min(fps, 60)) * .1) * Math.random()

      # append our data to the jquery object so we can access it later
      layer.data(data)

      t = "translateX(#{x}px) translateY(#{y}px) translateZ(#{z}px) rotateZ(#{a}deg) scale(#{s})"
      layer.css(transform: t)

      layer.appendTo(@cloudBase)

      @layers.push(layer)
