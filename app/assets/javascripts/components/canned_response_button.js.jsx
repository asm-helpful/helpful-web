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

  render: function() {
    return (
      <div className="btn-group command-bar-action">
        <button className="btn btn-default dropdown-toggle" data-toggle="dropdown" onClick={this.focusInput}>
          Canned Response {' '}
          <span className="caret"></span>
        </button>
        <ul className="dropdown-menu" role="menu">
          <li>
            <input type="text" className="form-control" placeholder="Search by key" onClick={this.ignore} />
          </li>
          <li className="divider"></li>
          {this.state.cannedResponses.map(function(cannedResponse) {
            return (
              <li>
                <a href="#">
                  {cannedResponse.key}
                </a>
              </li>
            );
          })}
        </ul>
      </div>
    );
  }
});
