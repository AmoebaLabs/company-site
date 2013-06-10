AmoebaSite.Helpers.AnimationHelper =
  scrollToTop: (animationTime = 0) ->
    @scrollToOffset(0, animationTime)

  scrollToOffset: (offset, animationTime = 0) ->
    if animationTime > 0
      $('body, html').animate({scrollTop: "#{offset}px"}, animationTime, 'swing')
    else
      $('body, html').scrollTop(offset)

Amoeba.Helpers.register AmoebaSite.Helpers.AnimationHelper
