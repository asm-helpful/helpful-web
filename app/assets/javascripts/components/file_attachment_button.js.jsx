/** @jsx React.DOM */

var FileAttachmentButton = React.createClass({
  render: function() {
    return (
      <div className="btn-group command-bar-action">
        <button className="btn btn-default">
          Attach files
          <span className="counter"></span>
        </button>
      </div>
    );
  }
});
