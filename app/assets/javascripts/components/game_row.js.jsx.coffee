root = exports ? this

root.GameRow = React.createClass
  mixins: [React.addons.PureRenderMixin]
  render: ->
    `<tr>
      <td>{this.props.data.title}</td>
      <td>{this.props.data.publisher || this.props.data.developer}</td>
      <td>{this.props.data.released_on}</td>
    </tr>`
