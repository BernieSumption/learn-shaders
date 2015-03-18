


class Chapter

  H1_REGEX = /^(?=#[^#]+)/m

  @fromMarkdown = (source) ->

    pages = for page, i in source.trim().split(H1_REGEX)
      try
        Page.fromMarkdown(page)
      catch e
        throw new Error("Error in page #{i+1}: #{e.message}")


    return new Chapter(pages)

  constructor: (@pages) ->
    @title = @pages[0].title


