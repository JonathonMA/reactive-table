root = exports ? this

# TablePage -- render a <tbody> containing a row per data item
#           -- OR; if the data isn't loaded, show a loading spinner
root.TablePage = React.createClass
  mixins: [React.addons.PureRenderMixin]
  render: ->
    if @props.items
      rows = (@_renderRow(item) for item in @props.items)
      `<tbody>{rows}</tbody>`
    else
      @_placeHolder()
  _rowElement: -> root[@props.rowComponent]
  _renderRow: (data) ->
    React.createElement(@_rowElement(), {
      key: data.id,
      data: data,
    })
  _placeHolder: ->
    loadingStyle = {
      height: "#{@props.assumedPageHeight}px",
      textAlign: "center",
    }
    loading = `<img src="/assets/loading_bar.gif" />`
    rows = `<tr><td style={loadingStyle}>{loading}</td></tr>`
    `<tbody className="loading">{rows}</tbody>`
