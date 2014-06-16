/** @jsx React.DOM */

var CannedResponseButton = React.createClass({
  getInitialState: function() {
    return {
      cannedResponses: []
    };
  },

  componentDidMount: function() {
    this.getCannedResponses();
  },

  getCannedResponses: function() {
    $.getJSON(this.props.source, function(response) {
      response.cannedResponses = [];
      this.setState({ cannedResponses: response.cannedResponses });
    }.bind(this));
  },

  render: function() {
    return (
      <div className="btn-group command-bar-action">
        <button className="btn btn-default dropdown-toggle" data-toggle="dropdown">
          Canned Response {' '}
          <span className="caret"></span>
        </button>
        <ul className="dropdown-menu" role="menu">
          <li>
            <input type="text" className="form-control" placeholder="Search by key" />
          </li>
          <li className="divider"></li>
          {this.state.cannedResponses.map(function(cannedResponse) {
            return (
              <li>
                <a href="#">
                  {cannedResponse}
                </a>
              </li>
            );
          })}
        </ul>
      </div>
    );
  }
});
