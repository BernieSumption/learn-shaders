

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
    @_chapterView = new ChapterView(document.getElementById('views-chapter'))
    @_chapters = {}

    if Tamarind.browserSupportsRequiredFeatures()
      page('/', @_defer(@_displayHome))
      page('/chapter/:chapter/:page?', @_defer(@_handleNavigateToChapter))
      page('*', @_defer(@_displayNotFound))
      page.start()
    else
      @_displayNotSupported()

  # page.js calls the page enter function before the URL changes, causing assets
  # to load relative to the previous page's URL. This gives the URL a chance to change
  # ensuring correct relative paths
  _defer: (f) ->
    self = @
    return (arg) ->
      deferred = ->
        f.call(self, arg)
        return
      console.log document.location.href
      setTimeout(deferred, 1)
      return

  _displayHome: ->
    @_viewsElement.className = 'is-home'
    return


  _displayNotFound: ->
    @_viewsElement.className = 'is-not-found'
    return


  _displayNotSupported: ->
    @_viewsElement.className = 'is-not-supported'
    return


  _handleNavigateToChapter: (context) ->
    @_loadChapter(context.params.chapter, context.params.page)
    return


  # Show a chapter
  _loadChapter: (chapterName, pageNumber) ->
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
          @_displayNotFound()
          return
      })

    return

  _displayChapter: (chapter, pageNumber) ->
    @_chapterView.display(chapter, pageNumber)
    @_viewsElement.className = 'is-chapter'
    return



