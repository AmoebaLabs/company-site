jQuery ($) ->


# SNG
  $(".contactus-button").on 'click', (e) ->
    STH.contactevt()

    # Stop event propagation
    return false


	animationTime = 1000

	$(".contactus-button").on 'click', (e) ->
		# Must hide the unnecessary elements
		$.each ["#logo", ".capabilities"], (index, klass) ->
			$(klass).fadeOut(animationTime)

		# .contactus is used to position/ animate the mascot for the contactus form
		$("#mascot").addClass("contactus")

		# Show the sayhi & contactus divs
		$("#contact-questions").fadeIn(animationTime)
		$("#contactus").removeClass("hidden")

		# Slide in Header
		$("#header").slideDown();

		# Consider scrolling to top of the page

		# Stop event propagation
		return false

	$(".team-button").on 'click', (e) ->
		# Move footer
		footer = $("#footer")
		footer.fadeOut animationTime, ->
			footer.addClass("team")
			footer.show()

		# Show team
		team = $("#team")
		team.fadeIn animationTime
		
		# Scroll to the top of the #team div
		teamOffset = team.offset().top-150
		$('body,html').animate({scrollTop: '+=' + teamOffset + 'px'}, animationTime)

	# Slide in Header in times
	header = $("#header")
	logoNav = $("#logo nav")
	$(document).on 'scroll.header', ->
		if $(this).scrollTop() < logoNav.offset().top
			header.slideUp()
		else header.slideDown()
