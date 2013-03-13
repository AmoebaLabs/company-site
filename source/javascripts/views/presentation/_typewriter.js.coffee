
class AmoebaSite.Typewriter
  constructor: (@parentDiv, @message, @callback) ->
    @fontSize = 1

  tearDown: () =>
    if @container
      @container.remove()
      @container = undefined

  write: (bottom) =>
    # remove any previous message if one exists
    this.tearDown()

    @container = $('<div/>')
      .appendTo(@parentDiv)
      .css(
        position: "absolute"
        bottom: bottom
        left: 0
        width: 0
        height: 200
        overflow: 'hidden'
      )
    message = $('<div/>')
      .text(@message)
      .appendTo(@container)
      .attr(class: "amoebaText")
      .css(
        fontSize: "#{@fontSize}em"
        position: "absolute"
        textAlign: "center"
        top: 0
        left: 0
        width: @parentDiv.width()
        textShadow: "white 0px 0px 4px"
        color: "#{AmoebaSite.Colors.amoebaGreenDark}"
      )

    @container.transition(
      width: '100%'
      duration: 8000
    )
