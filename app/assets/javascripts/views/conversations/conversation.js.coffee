class Helpful.Views.Conversation extends Backbone.View

  template: JST['conversations/conversation']

  tagName: 'div'

  className: 'list-item'

  events:
    'click': 'showConversation'

  showConversation: ->
    Backbone.history.navigate("conversations/#{@conversation.get('id')}", true)

  render: ->
    $(@el).html(@template(conversation: @model))
    this