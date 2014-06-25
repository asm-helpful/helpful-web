/** @jsx React.DOM */

var Router = Backbone.Router.extend({
  routes : {
    ':accountSlug/inbox': 'inbox',
    ':accountSlug/archived': 'archive',
    ':accountSlug/:conversationNumber': 'conversation'
  },

  inbox: function(accountSlug) {
    React.renderComponent(<ConversationList accountSlug={accountSlug} archived={false} />, $('.react')[0]);
  },

  archive: function(accountSlug) {
    React.renderComponent(<ConversationList accountSlug={accountSlug} archived={true} />, $('.react')[0]);
  },

  conversation: function(accountSlug, conversationNumber) {
    React.renderComponent(<ConversationList accountSlug={accountSlug} conversationNumber={conversationNumber} />, $('.react')[0]);
  }
});


$(function() {
  window.router = new Router();
  Backbone.history.start({ pushState: true });
});
