root = exports ? this

# borrowed this (and its usage) from react-infinite-scroll
topPosition = (domElt) ->
  return 0 if !domElt
  domElt.offsetTop + topPosition(domElt.offsetParent)

viewportSize = ->
  w = h = null
  if (typeof window.innerWidth != 'undefined')
    w = window.innerWidth
    h = window.innerHeight
  else
    console.log("NEED polyfill for viewportSize")
    w = 640
    h = 480

  {w: w, h: h}

root.ViewportListener = React.createClass
  mixins: [React.addons.PureRenderMixin]
  getDefaultProps: ->
    {
      updateStrategy: "onScroll"
      tickInterval: 250
    }
  render: ->
    `<div />`
  _scrollToPage: (page, offset) ->
    elementPosition = @_topPosition()
    pagePosition = page * @props.assumedPageHeight
    viewportTop = pagePosition + offset + @_topPosition()
    window.scrollTo(0, viewportTop)
  _scrollToURLLocation: ->
    parser = document.createElement("a")
    parser.href = window.location
    page = parseInt(parser.search.replace(/[^0-9]*/, ""))
    fragment = parseInt(parser.hash.replace(/[^0-9]*/, ""))
    @_scrollToPage(page, fragment)
  componentDidMount: ->
    @_scrollToURLLocation()
    @attachScrollListener()
  componentWillUnmount: -> @detachScrollListener()
  _topPosition: ->
    topPosition @getDOMNode()
  _scrollTop: -> window.pageYOffset
  scrollListener: ->
    @props.onViewportChange(
      viewport: viewportSize(),
      scrollTop: @_scrollTop(),
      topPosition: @_topPosition()
    )
  tick: ->
    @scrollListener()
    setTimeout @tick, @props.tickInterval if @state.ticking
  attachScrollListener: ->
    if @props.updateStrategy == "onScroll"
      window.addEventListener('scroll', @scrollListener)
      window.addEventListener('resize', @scrollListener)
      @scrollListener()
    else
      @setState(ticking: true)
      @tick()
  detachScrollListener: ->
    if @props.updateStrategy == "onScroll"
      window.removeEventListener('scroll', @scrollListener)
      window.removeEventListener('resize', @scrollListener)
    else
      @setState(ticking: false)
