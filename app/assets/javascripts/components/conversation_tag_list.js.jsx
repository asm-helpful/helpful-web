/** @jsx React.DOM */

var ConversationTagList = React.createClass({
  render: function() {
    var renderTagLabel = function(tag) {
      return (
        <span className="tag-label small text-muted" key={tag}>
          #{tag}
        </span>
      )
    }

    return (
      <div className="tag-label-list">
        {this.props.tags.map(renderTagLabel)}
      </div>
    );
  }
});
