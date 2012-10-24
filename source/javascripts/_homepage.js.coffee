jQuery ($) ->
	animationTime = 1000

	$("#contactus-button").on 'click', (e) ->
		# Must hide the unnecessary elements
		$.each ["#header", ".capabilities"], (index, klass) ->
			$(klass).fadeOut(animationTime)

		# .contactus is used to position/ animate the mascot for the contactus form
		$("#mascot").addClass("contactus")

		# Show the sayhi & contactus divs
		$("#sayhi").fadeIn(animationTime)
		$("#contactus").removeClass("hidden")

		# Stop event propagation
		return false



