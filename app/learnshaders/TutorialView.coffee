



# TODO insert editor and init

define (require) ->

  class ArticleView

    @TEMPLATE = '''
      <div class="article-title"></div>
      <div class="article-pre-content"></div>
      <div class="article-editor"></div>
      <div class="article-post-content"></div>
    '''

    # @param wrapperElement a DOM element to render the UI in. If non-empty, must contain elements
    #                       with the same class names as defined in ArticleView.TEMPLATE. If empty,
    #                       will be populated with the HTML of ArticleView.TEMPLATE
    constructor: (wrapperElement) ->

      if wrapperElement.innerHTML.trim() is ''
        wrapperElement.innerHTML = ArticleView.TEMPLATE

      byClassName = (className) ->
        el = wrapperElement.querySelector className
        unless el
          throw new Error("No element .#{className} in wrapper")
        return el

      @titleElement = byClassName '.article-title'
      @preContentElement = byClassName '.article-pre-content'
      @editorElement = byClassName '.article-editor'
      @postContentElement = byClassName '.article-post-content'
      @tamarind =


    display: (article, chapter = 1) ->
      chapter = article.chapters[chapter - 1]

      @titleElement.innerHTML = chapter.title
      @preContentElement.innerHTML = marked.parse(chapter.preContent)
      @postContentElement.innerHTML = marked.parse(chapter.postContent)

      @_addImageLoadHandlers @preContentElement
      @_addImageLoadHandlers @postContentElement

      return

    _addImageLoadHandlers: (element) ->
      for img in element.querySelectorAll('img')
        console.log img.complete
        img.onerror = @_handleImageError

      return

    _handleImageError: ->
      console.log "Failed to load image: #{this.src}"
      console.error "Failed to load image: #{this.src}"
      return



  return ArticleView