
define ['learnshaders/Article'], (Article) ->


  expectParseError = (source, message) ->
    expect(-> Article.fromMarkdown source).toThrow(new Error(message))
    return

  describe 'Article', ->

    it 'should split by H1 header', ->

      a = '''

        # my title

        the pre content
        ##subtitle
        and more

        # another title

        <textarea>
        looks like a fragment
        shader to me
        </textarea>

        the post content
        and still more
      '''

      article = Article.fromMarkdown(a)

      expect(article.chapters[0].title).toEqual('my title')
      expect(article.chapters[1].title).toEqual('another title')

      return

    it 'should annotate parse errors with the chapter', ->

      expectParseError '''

        # my title

        <textarea></textarea>
        <textarea></textarea>

        # another title
      ''', 'Error in chapter 1: Only one editor permitted per section'

      return

    return

  return