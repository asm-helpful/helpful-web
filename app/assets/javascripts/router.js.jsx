/** @jsx React.DOM */

var Router = Backbone.Router.extend({
  routes : {
    ':accountSlug/inbox': 'inbox',
    ':accountSlug/archived': 'archive',
    ':accountSlug/search': 'search',
    ':accountSlug/search?q=:query': 'search',
    ':accountSlug/search?utf8=%E2%9C%93&q=:query': 'search',
    ':accountSlug/:conversationNumber': 'conversation'
  },

  inbox: function(accountSlug) {
    React.renderComponent(<ConversationList accountSlug={accountSlug} archived={false} />, $('.react')[0]);
  },

  archive: function(accountSlug) {
    React.renderComponent(<ConversationList accountSlug={accountSlug} archived={true} />, $('.react')[0]);
  },

  search: function(accountSlug, query) {
    React.renderComponent(<ConversationList accountSlug={accountSlug} query={query} />, $('.react')[0]);
  },

  conversation: function(accountSlug, conversationNumber) {
    React.renderComponent(<ConversationList accountSlug={accountSlug} conversationNumber={conversationNumber} />, $('.react')[0]);
  }
});


$(function() {
  window.router = new Router();
  Backbone.history.start({ pushState: true });
});
