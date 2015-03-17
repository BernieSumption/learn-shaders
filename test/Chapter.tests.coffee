

describe 'Chapter', ->

  expectParse = (source, results) ->
    ch = Chapter.fromMarkdown source
    for k, v of results
      expect(JSON.stringify(ch[k])).toEqual JSON.stringify(v)
    return

  expectParseError = (source, message) ->
    expect(-> Chapter.fromMarkdown source).toThrow(new Error(message))
    return


  it 'should parse its title from the first H1 header', ->

    expectParse '# my title', title: 'my title'

    expectParse '# \t  my title', title: 'my title'

    expectParse '#my title', title: 'my title'

    expectParse '\n# my title', title: 'my title'

    expectParse '# my title\nmore content', title: 'my title'

    expectParseError '## my title', 'Chapter must begin with H1'

    return

  it 'should parse out the preContent, editorConfig and postContent', ->

    # all three
    expectParse '''

      # my title

      the pre content

      and more

      <textarea>
      looks like a fragment
      shader to me
      </textarea>

      the post content

          and still more

    ''' , {
      title: 'my title'
      preContent: 'the pre content\n\nand more',
      editorConfig: 'looks like a fragment\nshader to me'
      postContent: 'the post content\n\n    and still more'
    }



    # no postContent
    expectParse '''
      # my title

      the pre content

      and more

      <textarea>
      looks like a fragment
      shader to me
      </textarea>

    ''', {
      title: 'my title'
      preContent: 'the pre content\n\nand more',
      editorConfig: 'looks like a fragment\nshader to me'
      postContent: ''
    }

    # no preContent
    expectParse '''

      # my title

      <textarea>
      looks like a fragment
      shader to me
      </textarea>

      the post content

          and still more

    ''' , {
      title: 'my title'
      preContent: '',
      editorConfig: 'looks like a fragment\nshader to me'
      postContent: 'the post content\n\n    and still more'
    }

    # no preContent or postContent
    expectParse '''

      # my title

      <textarea>
      looks like a fragment
      shader to me
      </textarea>


    ''' , {
      title: 'my title'
      preContent: '',
      editorConfig: 'looks like a fragment\nshader to me'
      postContent: ''
    }

    # no editor
    expectParse '''

      # my title

      the pre content

      and more

    ''' , {
      title: 'my title'
      preContent: 'the pre content\n\nand more',
      editorConfig: null
      postContent: ''
    }


    expectParseError '''
      # my title

      <textarea>
      shader one
      </textarea>

      <textarea>
      shader two
      </textarea>

    ''', 'Only one editor permitted per section'

    return

  return
