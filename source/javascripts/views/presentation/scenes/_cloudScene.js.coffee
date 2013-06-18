class AmoebaSite.CloudScene
  constructor: (@el, @callback) ->
    AmoebaSite.presentation.setBackground('blue')

    setTimeout(=>
      @controller = new AmoebaSite.CloudsController(@el, =>
        if @callback
          @callback()
      )
    , 300)

  tearDown: () =>
    AmoebaSite.presentation.setBackground('none')

    @controller?.tearDown()
    @controller = undefined

