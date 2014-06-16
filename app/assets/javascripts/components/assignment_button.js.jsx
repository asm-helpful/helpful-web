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

  filterAssignees: function(event) {
    $input = $(event.target);
    $dropdown = $input.closest('.dropdown-menu');
    $divider = $('li.divider', $dropdown);
    $divider.nextAll().show();

    var inputValue = $input.val();
    if (inputValue == "") {
      return;
    }

    var inputRegexp = new RegExp(inputValue, 'gi');

    $divider.nextAll().each(function() {
      if(!$(this).text().match(inputRegexp)) {
        $(this).hide();
      }
    });
  },

  assignConversationHandler: function(assignee) {
    return function(event) {
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
    $dropdown = $(event.target).closest('.dropdown-menu');
    $input = $('input', $dropdown);
    $input.val('');
    $dropdown.removeClass('open');
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
            <input type="text" className="form-control" placeholder="Search by name" onClick={this.ignore} onKeyUp={this.filterAssignees} />
          </li>
          <li className="divider"></li>
          {this.state.assignees.map(function(assignee, index) {
            if(!assignee.person) {
              return;
            }

            return (
              <li>
                <a href="#" onClick={this.assignConversationHandler(assignee)}>
                  <Avatar person={assignee.person} />
                  <span>{assignee.person.name}</span>
                </a>
              </li>
            );
          }.bind(this))}
        </ul>
      </div>
    );
  }
});
