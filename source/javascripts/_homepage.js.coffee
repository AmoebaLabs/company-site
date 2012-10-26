jQuery ($) ->
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

		# Slide in Nav bar
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

		$("#team").fadeIn(animationTime)


