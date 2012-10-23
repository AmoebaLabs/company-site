jQuery ($) ->
	animationTime = 1000

	$("#contactus-button").on 'click', (e) ->
		# Must hide the unnecessary elements
		$.each(["#header", "#footer", ".capabilities"], (index, klass) ->
			$(klass).fadeOut(animationTime)
		)

		# .contactus is used to position/ animate the mascot for the contactus form
		$("#mascot").addClass "contactus"
		#$("#mascot").animate({'width': 233, 'height': 322}, 1000)

		# Stop event propagation
		return false



