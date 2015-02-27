root = exports ? this

root.SparseTable = React.createClass
  mixins: [React.addons.PureRenderMixin]
  _paddingSection: (size, className) ->
    if size > 0
      style = {height: "#{size}px"}
      `<tbody className={className}><tr><td style={style}></td></tr></tbody>`
    else
      null
  render: ->
    `<table className="table table-condensed">
    {this._paddingSection(this.props.paddingPre, "pre")}
    {this.props.pages}
    {this._paddingSection(this.props.paddingPost, "post")}
    </table>`
