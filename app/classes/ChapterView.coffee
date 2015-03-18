




class ChapterView

  INITIAL_FRAGMENT_SHADER_HEADER = '''
    precision mediump float;
    uniform vec2 u_CanvasSize;
    varying vec2 v_position;


  '''

  INITIAL_FRAGMENT_SHADER = INITIAL_FRAGMENT_SHADER_HEADER + '''
    void main() {
      // enter your shader here
    }
  '''

  INITIAL_VSHADER_SOURCE = '''
    attribute float a_VertexIndex;
    varying vec2 v_position;

    void main() {
      // this is the default vertex shader. It positions 4 points, one in each corner clockwise from top left, creating a rectangle that fills the whole canvas.
      if (a_VertexIndex == 0.0) {
        v_position = vec2(-1, -1);
      } else if (a_VertexIndex == 1.0) {
        v_position = vec2(1, -1);
      } else if (a_VertexIndex == 2.0) {
        v_position = vec2(1, 1);
      } else if (a_VertexIndex == 3.0) {
        v_position = vec2(-1, 1);
      } else {
        v_position = vec2(0);
      }
      gl_Position.xy = v_position;
    }
  '''

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

    @tamarind = new ShaderEditor(@$('.chapter-editor-tamarind').get(0))

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

    if page.editorConfig
      if pageIndex is 0
        fragmentShader = INITIAL_FRAGMENT_SHADER
      else
        previousFragmentShader = @chapter.pages[pageIndex - 1].editorConfig
        if previousFragmentShader
          fragmentShader = INITIAL_FRAGMENT_SHADER_HEADER + previousFragmentShader
        else
          fragmentShader = INITIAL_FRAGMENT_SHADER
      @$('.chapter-editor').show()
      @tamarind.reset({
        canvas: {
          fragmentShaderSource: fragmentShader
          vertexShaderSource: INITIAL_VSHADER_SOURCE
          vertexCount: 4
          drawingMode: 'TRIANGLE_FAN'
        }
      })
      CodeMirror.runMode page.editorConfig, 'clike', @$('.chapter-editor-codesample').get(0)

      @$('.lang-javascript').each (i, el) ->
        CodeMirror.runMode $(el).text(), 'javascript', el
        return

    else
      @$('.chapter-editor').hide()

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


