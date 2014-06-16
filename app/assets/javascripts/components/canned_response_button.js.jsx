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
    $.getJSON(this.props.conversation.canned_responses_path, function(response) {
      this.setState({ cannedResponses: response.canned_responses });
    }.bind(this));
  },

  ignore: function(event) {
    $(event.target).parents('.command-bar-action').addClass('open');
  },

  focusInput: function(event) {
    var $input = $('input', $(event.target).parent().parent());
    setTimeout(function() { $input.focus() }, 0);
  },

  filterCannedResponses: function(event) {
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

  useCannedResponse: function(cannedResponse) {
    return function(event) {
      this.props.useCannedResponseHandler(cannedResponse)
      this.clearCannedResponseFilter(event);
    }.bind(this);
  },

  clearCannedResponseFilter: function(event) {
    $dropdown = $(event.target).closest('.dropdown-menu');
    $input = $('input', $dropdown);
    $input.val('');
    $dropdown.removeClass('open');
  },

  render: function() {
    return (
      <div className="btn-group command-bar-action">
        <button className="btn btn-default dropdown-toggle" data-toggle="dropdown" onClick={this.focusInput}>
          Canned Response {' '}
          <span className="caret"></span>
        </button>
        <ul className="dropdown-menu" role="menu">
          <li>
            <input type="text" className="form-control" placeholder="Search by key" onClick={this.ignore} onKeyUp={this.filterCannedResponses} />
          </li>
          <li className="divider"></li>
          {this.state.cannedResponses.map(function(cannedResponse) {
            return (
              <li>
                <a href="#" onClick={this.useCannedResponse(cannedResponse)}>
                  {cannedResponse.key}
                </a>
              </li>
            );
          }.bind(this))}
        </ul>
      </div>
    );
  }
});
