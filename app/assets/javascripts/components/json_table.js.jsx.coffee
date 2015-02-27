#= require components/viewport_listener
#= require components/sparse_table
#= require components/ajax_loaded_table_page

root = exports ? this

# Given an array of element heights, and a viewport top and bottom, returns:
# {
#   firstVisiblePage: the index of the first visible element,
#   lastVisiblePage: the index of the last visible element,
#   offset: number of pixels from the top of the viewport to the top of the first visible element
# }
castViewport = (pageHeights, viewportTop, viewportBottom) ->
  pageStart = -1
  currentHeight = 0
  # TODO: given an average page height, we could do better than a linear search
  for i in [0..pageHeights.length - 1]
    lastHeight = currentHeight
    currentHeight += pageHeights[i]
    if currentHeight > viewportTop && pageStart == -1
      pageStart = i
      offset = viewportTop - lastHeight
    if currentHeight > viewportBottom
      pageEnd = i
      break

  {
    firstVisiblePage: pageStart
    lastVisiblePage: pageEnd
    offset: offset
  }

class PageCache
  constructor: -> @cache = {}
  get: (source, page, notifyCallback) =>
    return @cache[page] if @cache[page]

    $.get source, {page: page}, (results) =>
      @cache[page] = results
      notifyCallback results

    return null

class PageCache
  constructor: -> @cache = {}
  get: (source, page, notifyCallback) ->
    return @cache[page] if @cache[page]

    $.get source, {page: page}, (results) =>
      @cache[page] = results
      notifyCallback results

    return null

root.JSONTable = React.createClass
  mixins: [React.addons.PureRenderMixin]
  # TODO: pageCache should just be a caching function, but :(
  getDefaultProps: -> {pageCache: new PageCache()}
  render: ->
    `<div>
      <ViewportListener
        onViewportChange={this.handleViewportChange}
        assumedPageHeight={this.props.assumedPageHeight}
        />
      <SparseTable
        pages={this._renderedPages()}
        paddingPre={this._prePadding()}
        paddingPost={this._postPadding()} />
    </div>`
  _plus: (acc, i) -> acc + i
  _prePadding: ->
    return 0 if @state.firstVisiblePage == 0

    @_pageHeights()[0..(@state.firstVisiblePage - 1)].reduce @_plus, 0
  _postPadding: ->
    return 0 if @state.lastVisiblePage == @state.pages.length - 1

    @_pageHeights()[@state.lastVisiblePage + 1..-1].reduce @_plus, 0
  _renderedPages: ->
    @state.pages[@state.firstVisiblePage..@state.lastVisiblePage]
  handleViewportChange: (data) ->
    viewportTop = data.scrollTop - data.topPosition
    viewportBottom = viewportTop + data.viewport.h

    cast = castViewport(@_pageHeights(), viewportTop, viewportBottom)

    firstVisiblePage = cast.firstVisiblePage
    lastVisiblePage = cast.firstVisiblePage

    firstVisiblePage = @_extendVisiblePage(firstVisiblePage, -2)
    lastVisiblePage = @_extendVisiblePage(lastVisiblePage, 2)

    @_setPageAndOffsetInURL(cast.firstVisiblePage, cast.offset)
    @setState(firstVisiblePage: firstVisiblePage, lastVisiblePage: lastVisiblePage)
  _extendVisiblePage: (page, delta) ->
    Math.min @props.pageCount-1, Math.max(0, page + delta)
  _pageHeights: -> @state.pages.map (page) -> page.props.pageHeight
  handlePageHeight: (page, height) ->
    newPages = @state.pages
    newPages[page - 1] = @_ajaxPageForPage(page, height)
    @setState(pages: newPages)
  _ajaxPageForPage: (page, pageHeight) ->
    `<AJAXLoadedTablePage
      key={page}
      source={this.props.source}
      page={page}
      handlePageHeight={this.handlePageHeight}
      pageHeight={pageHeight}
      rowComponent={this.props.rowComponent}
      pageCache={this.props.pageCache}
    />`
  # A wrong and gross hack
  _getPageFromURL: ->
    parser = document.createElement("a")
    parser.href = window.location
    page = parseInt(parser.search.replace(/[^0-9]*/, ""))
    page ||= 0
  _setPageAndOffsetInURL: (page, offset) ->
    window.history.replaceState({}, 'react', "/games/react?page=#{page}##{offset}")
  getInitialState: ->
    initialPage = @_getPageFromURL()
    {
      firstVisiblePage: initialPage,
      lastVisiblePage: initialPage,
      pages:
        (@_ajaxPageForPage(page, @props.assumedPageHeight) for page in [1..@props.pageCount])
    }
