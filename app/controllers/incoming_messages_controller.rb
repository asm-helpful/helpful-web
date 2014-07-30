class IncomingMessagesController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    content_type = 'application/json'

    if params[:callback].present?
      request.format = 'json'
      content_type = 'text/javascript'
    end

    account = Account.find_by(slug: params.fetch(:account))
    email = Mail::Address.new params.fetch(:email)
    author = MessageAuthor.new(account, email)
    attachment = params[:attachment]

    begin
      ActiveRecord::Base.transaction do
        conversation = Concierge.new(account, params).find_conversation

        @message = author.compose_message(conversation, params.fetch(:content))
        @message.save!

        @message.attachments.create(file: attachment) if attachment.present?

        respond_to do |format|
          format.html
          format.json do
            render json: @message,
              status: :created,
              callback: params[:callback],
              content_type: content_type
          end
        end
      end
    rescue ActiveRecord::RecordInvalid
      respond_to do |format|
        format.html
        format.json do
          render json: @message.errors,
             status: :unprocessable_entity,
             callback: params[:callback],
             content_type: content_type
        end
      end
    end
  end
end
