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
    $.getJSON(this.props.source, function(response) {
      response.tags = ['tag'];
      this.setState({ tags: response.tags });
    }.bind(this));
  },

  render: function() {
    return (
      <div className="btn-group command-bar-action">
        <button className="btn btn-default dropdown-toggle" data-search="tags" data-toggle="dropdown">
          Tag {' '}
          <span className="caret"></span>
        </button>
        <ul className="dropdown-menu" role="menu">
          <li>
            <input type="text" className="form-control" placeholder="Search by tag" />
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
