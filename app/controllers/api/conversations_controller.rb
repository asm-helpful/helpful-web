class Api::ConversationsController < ApplicationController
  respond_to :json

  def index
    inbox = ConversationsInbox.new(current_account, params[:q])
    @conversations = inbox.conversations

    # If there was a query (q) passed, use it for the search field value
    if params[:q]
      @query = params[:q]
    end

    if signed_in?
      if inbox.search?
        Analytics.track(user_id: current_user.id, event: 'Read Conversations Index')
      else
        Analytics.track(user_id: current_user.id, event: 'Searched For', properties: { query: inbox.query })
      end
    end

    render json: @conversations, root: false
  end
end