#= require components/table_page

root = exports ? this

# AJAXLoadedTablePage -- renders a TablePage with items, re-rendering after it loaded
#                     -- also notifies if its rendered height differs from assumed
root.AJAXLoadedTablePage = React.createClass
  mixins: [React.addons.PureRenderMixin]
  render: ->
    `<TablePage
      key={this.props.page}
      items={this.state.items}
      rowComponent={this.props.rowComponent}
      assumedPageHeight={this.props.pageHeight}
    />`
  getInitialState: ->
    {
      items: @props.pageCache.get(@props.source, @props.page, @handlePageData)
    }
  handlePageData: (data) -> @setState(items: data) if @isMounted()
  componentDidMount: -> @calculateHeight()
  componentDidUpdate: -> @calculateHeight()
  currentHeight: -> @getDOMNode().offsetHeight
  calculateHeight: ->
    height = @currentHeight()
    @props.handlePageHeight(@props.page, height) if height != @props.pageHeight
