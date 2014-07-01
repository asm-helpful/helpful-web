/** @jsx React.DOM */

var AssignmentButton = React.createClass({
  getInitialState: function() {
    return {
      assignees: [],
      filter: ''
    };
  },

  componentDidMount: function() {
    this.getAssignees();
  },

  getAssignees: function() {
    $.getJSON(this.props.conversation.assignees_path, function(response) {
      this.setState({ assignees: response.assignees });
    }.bind(this));
  },

  ignore: function(event) {
    $(event.target).parents('.command-bar-action').addClass('open');
  },

  focusInput: function(event) {
    var $input = $('input', $(event.target).closest('button').siblings('.dropdown-menu'));
    setTimeout(function() { $input.focus() }, 0);
  },

  filterAssignees: function(event) {
    this.setState({ filter: event.target.value });
  },

  assignConversationHandler: function(assignee) {
    return function(event) {
      event.stopPropagation();
      event.preventDefault();

      var assigneesPath = this.props.conversation.assignees_path;
      var data = { assignee_id: assignee.id };

      $.ajax({
        type: 'POST',
        url: assigneesPath,
        data: JSON.stringify(data),
        dataType: 'json',
        contentType: 'application/json',
        accepts: { json: 'application/json' },
        success: function(response) {
          this.addStreamItem(response.assignment_event);
          this.clearAssignmentFilter(event);
        }.bind(this)
      });
    }.bind(this);
  },

  addStreamItem: function(streamItem) {
    this.props.addStreamItemHandler(streamItem);
  },

  clearAssignmentFilter: function(event) {
    $dropdown = $(event.target).closest('.dropdown-menu').removeClass('open');
    this.setState({ filter: '' });
  },

  renderFilteredAssignees: function() {
    return this.state.assignees.map(function(assignee) {
      var missingPerson = !assignee.person;
      var useFilter = this.state.filter !== '';
      var regexp = new RegExp(this.state.filter, 'gi');
      var applyFilter = missingPerson || (useFilter && !assignee.person.name.match(regexp));

      if(!applyFilter) {
        return (
          <li key={assignee.id}>
            <a href="#" onClick={this.assignConversationHandler(assignee)}>
              <Avatar person={assignee.person} />
              <span>{assignee.person.name}</span>
            </a>
          </li>
        );
      }
    }.bind(this));
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
            <input type="text" className="form-control" placeholder="Search by name" value={this.state.filter} onClick={this.ignore} onChange={this.filterAssignees} />
          </li>
          <li className="divider"></li>
          {this.renderFilteredAssignees()}
        </ul>
      </div>
    );
  }
});
