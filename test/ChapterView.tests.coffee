


describe 'ChapterView', ->

  expectInnerHTML = (element, innerHTML) ->
    expected = element.innerHTML.trim().replace(/\s+/g, ' ')
    actual = innerHTML.trim().replace(/\s+/g, ' ')
    expect(JSON.stringify(expected)).toEqual JSON.stringify(actual)
    return


  it 'should console log an error when there is an image 404', (done) ->

    spyOn(console, 'error')


    a = Chapter.fromMarkdown '''

      # my title

      ![](doesntexist.jpg)
    '''

    wrapper = document.createElement 'div'
    av = new ChapterView(wrapper)
    av.display(a)

    interval = setInterval (->
      if console.error.calls.count() > 0
        expect(console.error).toHaveBeenCalled()
        expect(console.error.calls.mostRecent().args[0].indexOf('doesntexist.jpg')).toBeGreaterThan(0)
        clearInterval interval
        done()
      return
    ), 100




    return

  return
