/** @jsx React.DOM */

var Router = Backbone.Router.extend({
  routes : {
    ':accountSlug/inbox': 'inbox',
    ':accountSlug/archived': 'archive',
    ':accountSlug/:conversationNumber': 'conversation'
  },

  inbox: function(accountSlug) {
    React.renderComponent(<Inbox accountSlug={accountSlug} />, $('.react')[0]);
  },

  archive: function(accountSlug) {
    React.renderComponent(<Archive accountSlug={accountSlug} />, $('.react')[0]);
  },

  conversation: function(accountSlug, conversationNumber) {
    console.log('conversation');
  }
});


$(function() {
  window.router = new Router();
  Backbone.history.start({ pushState: true });
});
