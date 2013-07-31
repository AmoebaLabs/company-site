class AmoebaSite.Views.Homepage.Contactus extends Amoeba.View
  name: 'contactus'
  el: '#contactus'
  events:
    'submit #contact-form': 'submitForm'

  transitionIn: (from) ->
    animationTime = if from is 'none' then 0 else @parent.animationTime

    @helpers.scrollToTop(animationTime)
    @parent.showFooter(animationTime)
    @parent.mascot.show(animationTime)
    @parent.mascot.shrink(if from is 'home' then @parent.animationTime else 0)

    # Show the #contact-questions (sayhi) div
    $('#contact-questions').disolveIn(animationTime)

    @$el.removeClass("hidden")
    @$el.css
      perspective: '400px'
      opacity: 0
      rotateY: '-90deg'
    @$el.transition
      perspective: '400px'
      opacity: 1
      rotateY: '0deg'
      duration: animationTime
      easing: 'ease-in'
      complete: @parent.callbackHelper.callback()

  transitionOut: (to) ->
    animationTime = @parent.animationTime

    # hack that will be removed when refactored
    if @parent.mobileMode
      animationTime = 0

    if to is 'home'
      @parent.mascot.grow(animationTime)
    else
      @parent.mascot.hide(animationTime)

    # Hide the #contact-questions (sayhi) div
    $('#contact-questions').disolveOut(animationTime)

    # Hide the #contactus div
    @$el.disolveOut(animationTime)

  submitForm: (e) ->
    e.preventDefault()

    $name = $("input#contact-name")
    $company = $("input#contact-company")
    $email = $("input#contact-email")
    $message = $("textarea#contact-message")
    $error = $('.error-message')

    $error.addClass("invisible")

    if ($name.val() == "")
      $name.focus()
      $error.html("You must enter a valid name.")
      $error.removeClass("invisible")
      return false

    if ($company.val() == "")
      $company.focus()
      $error.html("You must enter a company.")
      $error.removeClass("invisible")
      return false

    emailRE = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/

    if ($email.val() == "" || !emailRE.test($email.val()))
      $email.focus()
      $error.html("You must enter a valid email.")
      $error.removeClass("invisible")
      return false

    if ($message.val() == "")
      $message.focus()
      $message.html("You must enter a message.")
      $message.removeClass("invisible")
      return false

    dataString = "name=#{$name.val()}&email=#{$email.val()}&company=#{$company.val()}&message=#{$message.val()}"
    $.ajax
      type: "POST"
      url: "/submit_contact.php"
      data: dataString
      success: =>
        $error.addClass("success")
        $error.html("Success!")
        $error.removeClass("invisible")
        setTimeout =>
          Backbone.history.navigate("/", trigger: true)
          $error.removeClass("success")
          $error.addClass("invisible")
          $name.val("")
          $company.val("")
          $email.val("")
          $message.val("")
        , 2000
      error: =>
        $error.html("Error: Invalid response. Please try again.")
        $error.removeClass("invisible")