/** @jsx React.DOM */

var AssignmentButton = React.createClass({
  getInitialState: function() {
    return {
      assignees: []
    };
  },

  componentDidMount: function() {
    this.getAssignees();
  },

  getAssignees: function() {
    $.getJSON(this.props.source, function(response) {
      response.users = [];
      this.setState({ assignees: response.users });
    }.bind(this));
  },

  render: function() {
    return (
      <div className="btn-group command-bar-action">
        <button className="btn btn-default dropdown-toggle" data-search="assignments" data-toggle="dropdown">
          Assign {' '}
          <span className="caret"></span>
        </button>
        <ul className="dropdown-menu" role="menu">
          <li>
            <input type="text" className="form-control" placeholder="Search by name" />
          </li>
          <li className="divider"></li>
          {this.state.assignees.map(function(assignee) {
            return (
              <li>
                <a href="#">
                  <Avatar person={assignee.person} />
                  {assignee.person.name}
                </a>
              </li>
            );
          })}
        </ul>
      </div>
    );
  }
});
