#= require jquery-1.8.2
#= require jquery.transit
#= require amoeba-js
#= require raphaeljs
#= require amoeba-storybook
#= require_self
#= require_tree ./lib
#= require_tree ./helpers
#= require_tree ./routers
#= require_tree ./views
#= require _app

window.AmoebaSite =
  Views: {}
  Helpers: {}
  Presentation: {}
  Colors:  # keep these synced with the identical css values in _variables.css.scss
    amoebaGreen: "#A6CC2F"
    amoebaGreenMedium: "#8BA400"
    amoebaGreenDark: "#384F0E"
    amoebaGrey: "#EAEBED"
    greenUltraDark: "#002C1F"
    greyLight: "#BEC0C6"
