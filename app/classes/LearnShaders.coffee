

class LearnShaders

  instanceCount = 0

  constructor: ->

    if instanceCount > 0
      throw new Error('Only one LearnShaders object can exist per page')

    ++instanceCount

    @tutorialView = new TutorialView(document.getElementById('content'))

    @tutorialContent = {}

    page('/tutorial/:tutorial/', @_handleNavigateToTutorial)
    page('/tutorial/:tutorial/:page', @_handleNavigateToTutorial)
    page.start()


  _handleNavigateToTutorial: (context) =>
    tutorial = context.params.tutorial
    page = Math.max(1, ~~context.params.page)
    if @tutorialContent[tutorial]
      @tutorialView.display(@tutorialContent[tutorial], page)
    else
      url = tutorial + '.md'
      console.log "Loading #{url}"
      $.ajax({
        url: url
        success: (data) =>
          @tutorialContent[tutorial] = Tutorial.fromMarkdown(data)
          @_handleNavigateToTutorial(context)
          return
        error: ->
          throw new Error('handle me!')
      })

    return

