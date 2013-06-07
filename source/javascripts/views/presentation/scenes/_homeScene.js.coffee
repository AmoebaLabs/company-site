
class AmoebaSite.HomeScene
  constructor: (@el, @callback) ->
    this._runSequence()

  tearDown: =>
    @cube?.tearDown()
    @cube = undefined

    @toolsScene?.tearDown()
    @toolsScene = undefined

    @cloudScene?.tearDown()
    @cloudScene = undefined


  _hideDiv: (theDiv, show) =>
    theDiv.css(
      display: if show == true then 'block' else 'none'
    )

  _runSequence: () =>
    @cube = new AmoebaSite.CubeScene(@el, =>
      @cube.tearDown()
      @cube = undefined

      # short curcuit to get the start and end polished
      this.sequenceDone()

#      @toolsScene = new AmoebaSite.ToolsScene(@el, =>
#        @toolsScene.tearDown()
#        @toolsScene = undefined
#
#        @cloudScene = new AmoebaSite.CloudScene(@el, =>
#          # keep the clouds on for a few seconds
#          setTimeout(=>
#            this.sequenceDone()
#          , 2000)
#        )
#      )
#
#      @toolsScene.start()
    )

  sequenceDone: =>
    # old shit, throw away if not used
    #          @cloudScene.tearDown()
    #          @cloudScene = undefined
    #          AmoebaSite.presentation.setBackground('black')
    #          this._hideDiv(@mascot, true)

    # we're done, call the callback
    this.callback?()


