


class Chapter

  H1_REGEX = /^#(?!#)\s*(.*)/

  TEXTAREA_REGEX = /^([\s\S]*)<textarea>([\s\S]*)<\/textarea>([\s\S]*)$/im

  @fromMarkdown = (source) ->
    source = source.trim()

    match = H1_REGEX.exec(source)

    unless match
      console.log('Bad markdown source: ' + source)
      throw new Error('Chapter must begin with H1')

    title = match[1]
    source = source.replace(H1_REGEX, '').trim()

    match = TEXTAREA_REGEX.exec(source)
    if match
      preContent = match[1].trim()
      editorConfig = match[2].trim()
      postContent = match[3].trim()
    else
      preContent = source
      editorConfig = null
      postContent = ''

    if TEXTAREA_REGEX.test(preContent)
      throw new Error('Only one editor permitted per section')


    return new Chapter(title, preContent, postContent, editorConfig)

  constructor: (@title, @preContent, @postContent, @editorConfig) ->


