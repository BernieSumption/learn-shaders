


describe 'ChapterView', ->

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

  it 'should progressively enhance "reveal answer" links', ->

    spyOn(console, 'error')

    a = Chapter.fromMarkdown '''

      # my title

      [correct style](# "Secret answer!")

      [wrong href](lala "Quux")

      [no title](#)
    '''

    wrapper = document.createElement 'div'
    av = new ChapterView(wrapper)
    av.display(a)

    links = $(wrapper).find('.chapter-content a').get()

    expect(links[0].onclick).toEqual(ChapterView.prototype._linkClickHandler)
    expect(links[1].onclick).toBeNull()
    expect(links[2].onclick).toBeNull()

    return


  return
