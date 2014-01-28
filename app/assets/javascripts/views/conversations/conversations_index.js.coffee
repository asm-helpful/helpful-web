class Helpful.Views.ConversationsIndex extends Backbone.View

  template: JST['conversations/index']

  initialize: ->
    @collection.on('sync', @render, this)

  render: ->
    $(@el).html(@template())
    @collection.each(@appendConversation)
    this

  appendConversation: (conversation) ->
    view = new Helpful.Views.Conversation(model: conversation)
    $('#conversations .list').append(view.render().el)
