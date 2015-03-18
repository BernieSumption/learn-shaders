

describe 'Chapter', ->

  expectParseError = (source, message) ->
    expect(-> Chapter.fromMarkdown source).toThrow(new Error(message))
    return

  it 'should split by H1 header', ->

    a = '''

      # my title

      the pre content
      ##subtitle
      and more

      # another title

      ```editor
      looks like a fragment
      shader to me
      ```

      the post content
      and still more
    '''

    chapter = Chapter.fromMarkdown(a)

    expect(chapter.pages[0].title).toEqual('my title')
    expect(chapter.pages[1].title).toEqual('another title')

    return

  it 'should annotate parse errors with the page', ->

    expectParseError '''

      # my title

      ```editor
      ```

      ```editor
      ```

      # another title
    ''', 'Error in page 1: Only one editor permitted per section'

    return

  return
