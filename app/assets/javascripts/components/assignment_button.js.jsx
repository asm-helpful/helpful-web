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
    $.getJSON(this.props.conversation.assignees_path, function(response) {
      response.users = [];
      this.setState({ assignees: response.assignees });
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
        <button className="btn btn-default dropdown-toggle" data-search="assignments" data-toggle="dropdown" onClick={this.focusInput}>
          Assign {' '}
          <span className="caret"></span>
        </button>
        <ul className="dropdown-menu" role="menu">
          <li>
            <input type="text" className="form-control" placeholder="Search by name" onClick={this.ignore} />
          </li>
          <li className="divider"></li>
          {this.state.assignees.map(function(assignee) {
            if(!assignee.person) {
              return;
            }

            return (
              <li>
                <a href="#">
                  <Avatar person={assignee.person} />
                  <span>{assignee.person.name}</span>
                </a>
              </li>
            );
          })}
        </ul>
      </div>
    );
  }
});
