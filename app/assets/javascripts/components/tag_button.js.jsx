/** @jsx React.DOM */

var TagButton = React.createClass({
  getInitialState: function() {
    return {
      tags: [],
      newTag: ''
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

  filterTags: function(event) {
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

  tagConversationHandler: function(tag) {
    return function(event) {
      var tagsPath = this.props.conversation.tags_path;
      var data = { tag: tag };

      $.ajax({
        type: 'POST',
        url: tagsPath,
        data: JSON.stringify(data),
        dataType: 'json',
        contentType: 'application/json',
        accepts: { json: 'application/json' },
        success: function(response) {
          this.addStreamItem(response.tag_event);
          this.clearTagFilter(event);
        }.bind(this)
      });
    }.bind(this);
  },

  addStreamItem: function(streamItem) {
    this.props.addStreamItemHandler(streamItem);
  },

  clearTagFilter: function(event) {
    $dropdown = $(event.target).closest('.dropdown-menu');
    $dropdown.removeClass('open');
    this.setState({
      newTag: ''
    });
  },

  updateNewTag: function(event) {
    this.setState({
      newTag: event.target.value
    });
  },

  render: function() {
    var showNewTag = this.state.newTag !== '' && !!this.state.tags.indexOf(this.state.newTag);

    return (
      <div className="btn-group command-bar-action">
        <button className="btn btn-default dropdown-toggle" data-search="tags" data-toggle="dropdown" onClick={this.focusInput}>
          Tag {' '}
          <span className="caret"></span>
        </button>
        <ul className="dropdown-menu" role="menu">
          <li>
            <input type="text" className="form-control" placeholder="Search by tag" onClick={this.ignore} onChange={this.updateNewTag} value={this.state.newTag} />
          </li>
          <li className="divider"></li>
          {showNewTag ? <li><a href="#"onClick={this.tagConversationHandler(this.state.newTag)}>{this.state.newTag}</a></li> : ''}
          {this.state.tags.map(function(tag) {
            return (
              <li>
                <a href="#" onClick={this.tagConversationHandler(tag)}>
                  {tag}
                </a>
              </li>
            );
          }.bind(this))}
        </ul>
      </div>
    );
  }
});
