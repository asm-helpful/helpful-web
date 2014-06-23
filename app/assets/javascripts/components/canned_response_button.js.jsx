/** @jsx React.DOM */

var CannedResponseButton = React.createClass({
  getInitialState: function() {
    return {
      cannedResponses: [],
      filter: ''
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
    this.setState({ filter: event.target.value });
  },

  useCannedResponse: function(cannedResponse) {
    return function(event) {
      this.props.useCannedResponseHandler(cannedResponse)
      this.clearCannedResponseFilter(event);
    }.bind(this);
  },

  clearCannedResponseFilter: function(event) {
    $dropdown = $(event.target).closest('.dropdown-menu').removeClass('open');
    this.setState({ filter: '' });
  },

  renderFilteredCannedResponses: function() {
    return this.state.cannedResponses.map(function(cannedResponse) {
      var useFilter = this.state.filter !== '';
      var regexp = new RegExp(this.state.filter, 'gi');
      var applyFilter = useFilter && !cannedResponse.key.match(regexp);

      if(!applyFilter) {
        return (
          <li key={cannedResponse.key}>
            <a href="#" onClick={this.useCannedResponse(cannedResponse)}>
              {cannedResponse.key}
            </a>
          </li>
        );
      }
    }.bind(this));
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
          {this.renderFilteredCannedResponses()} 
        </ul>
      </div>
    );
  }
});
