

###
  This class controls the browser window, delegating to other classes like
  ChapterView as appropriate
###
class LearnShaders

  instanceCount = 0

  constructor: ->

    if instanceCount > 0
      throw new Error('Only one LearnShaders object can exist per page')

    ++instanceCount

    @_viewsElement = document.getElementById('views')

    @chapterView = new ChapterView(document.getElementById('views-chapter'))

    @_chapters = {}

    page('/chapter/:chapter/:page?', @_handleNavigateToChapter)
    page.start()


  _handleNavigateToChapter: (context) =>
    @loadChapter(context.params.chapter, context.params.page)
    return


  # Show a chapter
  loadChapter: (chapterName, pageNumber) ->
    if @_chapters[chapterName]
      @_displayChapter(@_chapters[chapterName], pageNumber)
    else
      url = chapterName + '.md'
      console.log "Loading #{url}"
      $.ajax({
        url: url
        success: (data, status, xhr) =>
          console.log "Loaded from #{xhr.responseURL}"
          @_chapters[chapterName] = Chapter.fromMarkdown(data)
          @_displayChapter(@_chapters[chapterName], pageNumber)
          return
        error: ->
          throw new Error('handle me!')
      })

    return

  _displayChapter: (chapter, pageNumber) ->
    @chapterView.display(chapter, pageNumber)
    @_viewsElement.className = 'is-chapter'
    return



