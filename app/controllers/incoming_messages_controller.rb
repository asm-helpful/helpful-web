class IncomingMessagesController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    account = Account.find_by(slug: params.fetch(:account))
    email = Mail::Address.new params.fetch(:email)
    author = MessageAuthor.new(account, email)

    conversation = Concierge.new(account, params).find_conversation
    @message = author.compose_message(conversation, params.fetch(:content))

    content_type = 'application/json'

    if params[:callback].present?
      request.format = 'json'
      content_type = 'text/javascript'
    end

    if @message.save
      if !params[:attachment].nil?
        # TODO: Should handle error here if attachment is not saved? Attachment need a record to be saved so relation can be mapped.
        @message.attachments.create(file: params.fetch(:attachment))
      end

      respond_to do |format|
        format.html
        format.json do
          render :json => @message,
                 :status => :created,
                 :callback => params[:callback],
                 :content_type => content_type
        end
      end

    else

      respond_to do |format|
        format.html
        format.json do
          render :json => @message.errors,
             :status => :unprocessable_entity,
             :callback => params[:callback],
             :content_type => content_type
        end
      end

    end
  end
end
