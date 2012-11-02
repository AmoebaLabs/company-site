jQuery ($) ->

	$(".contactus-button").on 'click', (e) ->
		STH.showContact()

		# Stop event propagation
		return false

	$(".team-button").on 'click', (e) ->
		STH.showTeam()

	# Slide in Header in times
	header = $("#header")
	logoNav = $("#logo nav")
	$(document).on 'scroll.header', ->
		if $(this).scrollTop() < logoNav.offset().top
			header.slideUp()
		else header.slideDown()
