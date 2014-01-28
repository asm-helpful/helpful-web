class Helpful.Routers.Conversations extends Backbone.Router
  routes:
    ':account/conversations': 'index'

  initialize: ->
    @collection = new Helpful.Collections.Conversations()

  index: ->
    @collection.fetch()
    view = new Helpful.Views.ConversationsIndex(collection: @collection)
    # $('#conversations .list').html(view.render().el)