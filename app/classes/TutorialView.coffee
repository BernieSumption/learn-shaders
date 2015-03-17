




class TutorialView

  @TEMPLATE = '''
    <div class="article-title"></div>
    <div class="article-pre-content"></div>
    <div class="article-editor"></div>
    <div class="article-post-content"></div>
  '''

  # @param wrapperElement a DOM element to render the UI in. If non-empty, must contain elements
  #                       with the same class names as defined in TutorialView.TEMPLATE. If empty,
  #                       will be populated with the HTML of TutorialView.TEMPLATE
  constructor: (wrapperElement) ->


    if wrapperElement.innerHTML.trim() is ''
      wrapperElement.innerHTML = TutorialView.TEMPLATE

    @_wrapper = $(wrapperElement)

    @tamarind = new ShaderEditor(@$('.article-editor').get(0))

    @chapterIndex = 1

  $: (css) ->
    return @_wrapper.find(css)

  display: (@article, chapterNo = 1) ->
    @chapterNo = Math.max(1, Math.min(~~chapterNo, article.chapters.length))
    chapter = @article.chapters[@chapterNo - 1]

    @$('.article-title').html(chapter.title)
    preContent = @$('.article-pre-content')
    preContent.html(marked.parse(chapter.preContent))
    postContent = @$('.article-post-content')
    postContent.html(marked.parse(chapter.postContent))

    postContent.add(preContent).find('img').on('error', @_handleImageError)

    @tamarind.reset({
      canvas: {
        fragmentShaderSource: chapter.editorConfig
        vertexShaderSource: WebGLCanvas.DEFAULT_VSHADER_SOURCE
        vertexCount: 4
        drawingMode: 'TRIANGLE_FAN'
      }
    })

    if chapterNo > 1
      @$('.article-previous-page-link').show().attr('href', chapterNo - 1)
    else
      @$('.article-previous-page-link').hide()

    if chapterNo < article.chapters.length
      @$('.article-next-page-link').show().attr('href', chapterNo + 1)
    else
      @$('.article-next-page-link').hide()

    return

  _goToRelativePage: (offset) ->
    @display(@article, @chapterNo + offset)
    return false


  _handleImageError: ->
    console.log "Failed to load image: #{this.src}"
    console.error "Failed to load image: #{this.src}"
    return


