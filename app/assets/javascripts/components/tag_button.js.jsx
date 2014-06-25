/** @jsx React.DOM */

var TagButton = React.createClass({
  getInitialState: function() {
    return {
      tags: [],
      newTag: '',
      filter: ''
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
    var $input = $('input', $(event.target).closest('.dropdown-menu'));
    setTimeout(function() { $input.focus() }, 0);
  },

  filterTags: function(event) {
    this.setState({ filter: event.target.value });
  },

  tagConversationHandler: function(tag) {
    return function(event) {
      event.stopPropagation();
      event.preventDefault();

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
    $dropdown = $(event.target).closest('.dropdown-menu').removeClass('open');

    this.setState({
      newTag: '',
      filter: ''
    });
  },

  updateNewTag: function(event) {
    this.setState({
      newTag: event.target.value,
      filter: event.target.value
    });
  },

  showNewTag: function() {
    return this.state.newTag !== '' && this.state.tags.indexOf(this.state.newTag) < 0;
  },

  renderNewTag: function() {
    if(this.showNewTag()) {
      return (
        <li>
          <a href="#" onClick={this.tagConversationHandler(this.state.newTag)}>
            {this.state.newTag}
          </a>
        </li>
      );
    }
  },

  renderFilteredTags: function() {
    return this.state.tags.map(function(tag) {
      var useFilter = this.state.filter !== '';
      var regexp = new RegExp(this.state.filter, 'gi');
      var applyFilter = useFilter && !tag.match(regexp);

      if(!applyFilter) {
        return (
          <li key={tag}>
            <a href="#" onClick={this.tagConversationHandler(tag)}>
              {tag}
            </a>
          </li>
        );
      }
    }.bind(this));
  },

  render: function() {
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
          {this.renderNewTag()}
          {this.renderFilteredTags()}
        </ul>
      </div>
    );
  }
});
