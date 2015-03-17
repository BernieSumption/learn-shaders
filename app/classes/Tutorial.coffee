


class Tutorial

  H1_REGEX = /^(?=#[^#]+)/m

  @fromMarkdown = (source) ->

    chapters = for chapter, i in source.trim().split(H1_REGEX)
      try
        Chapter.fromMarkdown(chapter)
      catch e
        throw new Error("Error in chapter #{i+1}: #{e.message}")


    return new Tutorial(chapters)

  constructor: (@chapters) ->


