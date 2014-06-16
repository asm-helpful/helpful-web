/** @jsx React.DOM */

var TagButton = React.createClass({
  getInitialState: function() {
    return {
      tags: []
    };
  },

  componentDidMount: function() {
    this.getTags();
  },

  getTags: function() {
    $.getJSON(this.props.conversation.tags_path, function(response) {
      this.setState({ tags: response.tags });
    }.bind(this));
  },

  ignore: function(event) {
    $(event.target).parents('.command-bar-action').addClass('open');
  },

  focusInput: function(event) {
    var $input = $('input', $(event.target).parent().parent());
    setTimeout(function() { $input.focus() }, 0);
  },

  render: function() {
    return (
      <div className="btn-group command-bar-action">
        <button className="btn btn-default dropdown-toggle" data-search="tags" data-toggle="dropdown" onClick={this.focusInput}>
          Tag {' '}
          <span className="caret"></span>
        </button>
        <ul className="dropdown-menu" role="menu">
          <li>
            <input type="text" className="form-control" placeholder="Search by tag" onClick={this.ignore} />
          </li>
          <li className="divider"></li>
          {this.state.tags.map(function(tag) {
            return (
              <li>
                <a href="#">
                  {tag}
                </a>
              </li>
            );
          })}
        </ul>
      </div>
    );
  }
});
