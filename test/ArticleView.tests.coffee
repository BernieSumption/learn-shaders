
define (require) ->

  Article = require 'learnshaders/Article'
  ArticleView = require 'learnshaders/ArticleView'

  expectInnerHTML = (element, innerHTML) ->
    expected = element.innerHTML.trim().replace(/\s+/g, ' ')
    actual = innerHTML.trim().replace(/\s+/g, ' ')
    expect(JSON.stringify(expected)).toEqual JSON.stringify(actual)
    return

  describe 'ArticleView', ->

    it 'should display the parsed article content on demand', ->

      a = Article.fromMarkdown '''

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

      wrapper = document.createElement 'div'
      av = new ArticleView(wrapper)

      av.display(a)

      expectInnerHTML av.titleElement, 'my title'

      expectInnerHTML av.preContentElement, '''
        <p>the pre content</p>
        <h2 id="subtitle">subtitle</h2>
        <p>and more</p>
      '''

      expectInnerHTML av.postContentElement, ''



      av.display(a, 2)

      expectInnerHTML av.titleElement, 'another title'

      expectInnerHTML av.preContentElement, ''

      expectInnerHTML av.postContentElement, '''
        <p>the post content and still more</p>
      '''


      return


    it 'should console log an error when there is an image 404', (done) ->

      spyOn(console, 'error')


      a = Article.fromMarkdown '''

        # my title

        ![](doesntexist.jpg)
      '''

      wrapper = document.createElement 'div'
      av = new ArticleView(wrapper)
      av.display(a)

      interval = setInterval (->
        if console.error.calls.count() > 0
          debugger
          expect(console.error).toHaveBeenCalled()
          expect(console.error.calls.mostRecent().args[0].indexOf('doesntexist.jpg')).toBeGreaterThan(0)
          clearInterval interval
          done()
        return
      ), 100




      return

    return

  return