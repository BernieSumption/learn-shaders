




class ChapterView

  @TEMPLATE = '''
    <div class="chapter-title"></div>
    <div class="chapter-pre-content"></div>
    <div class="chapter-editor"></div>
    <div class="chapter-post-content"></div>
  '''

  # @param wrapperElement a DOM element to render the UI in. If non-empty, must contain elements
  #                       with the same class names as defined in ChapterView.TEMPLATE. If empty,
  #                       will be populated with the HTML of ChapterView.TEMPLATE
  constructor: (wrapperElement) ->


    if wrapperElement.innerHTML.trim() is ''
      wrapperElement.innerHTML = ChapterView.TEMPLATE

    @_wrapper = $(wrapperElement)

    @tamarind = new ShaderEditor(@$('.chapter-editor').get(0))

    @pageIndex = 1

  $: (css) ->
    return @_wrapper.find(css)

  display: (@chapter, pageNo = 1) ->
    pageNo = ~~pageNo
    clampedPageNo = Math.max(1, Math.min(~~pageNo, @chapter.pages.length))
    unless pageNo is clampedPageNo
      window.page.show(String(clampedPageNo))
      return

    pageIndex = pageNo - 1
    page = @chapter.pages[pageIndex]

    @$('.chapter-title').html(chapter.title)
    @$('.page-title').html(page.title)
    preContent = @$('.chapter-pre-content')
    preContent.html(@_parseMarkdown(page.preContent))
    postContent = @$('.chapter-post-content')
    postContent.html(@_parseMarkdown(page.postContent))

    postContent.add(preContent).find('img').on('error', @_handleImageError)

    @tamarind.reset({
      canvas: {
        fragmentShaderSource: page.editorConfig
        vertexShaderSource: WebGLCanvas.DEFAULT_VSHADER_SOURCE
        vertexCount: 4
        drawingMode: 'TRIANGLE_FAN'
      }
    })

    if pageNo > 1
      @$('.chapter-previous-page-link').show().attr('href', pageNo - 1)
    else
      @$('.chapter-previous-page-link').hide()

    if pageNo < chapter.pages.length
      @$('.chapter-next-page-link').show().attr('href', pageNo + 1)
      @$('.chapter-next-page-title').html(chapter.pages[pageIndex + 1].title)
    else
      @$('.chapter-next-page-link').hide()

    @$('.chapter-current-page').html(pageNo)
    @$('.chapter-total-pages').html(chapter.pages.length)

    return

  _parseMarkdown: (source) ->
    html = marked.parse(source)
    # catch the annoying bug where markdown treats a_b c_ as 'a<em>b c</em>' despite not being supposed to
    if match = /\w+<em>\w*/.exec(html)
      throw new Error('Italic block starts in middle of word: ' + match[0])
    return html

  _handleImageError: ->
    console.log "Failed to load image: #{this.src}"
    console.error "Failed to load image: #{this.src}"
    return


