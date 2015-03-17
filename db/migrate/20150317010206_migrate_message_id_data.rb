class MigrateMessageIdData < ActiveRecord::Migration
  def up

    # Give all messages message ids

    Message.where(message_id: nil).find_in_batches do |messages|
      messages.each do |m|
        m.update_column(:message_id,
          if m.webhook? && m.webhook.has_key?('Message-Id')
            m.webhook.fetch('Message-Id')
          else
            "<#{m.id}@helpful.mail>"
          end
        )
      end
    end

    # Calculate in-reply-tos for all messages

    Conversation.find_in_batches do |convos|
      convos.each do |c|
        msgs = c.messages.order(:created_at)
        msgs.each_with_index do |m, idx|
          next if idx == 0
          m.update_column(:in_reply_to_id, msgs[idx - 1].id)
        end
      end
    end

    # Correct weird conversations that wernt threaded correctly

    Conversation.find_in_batches do |cs|
      cs.each do |c|
        next if c.messages.empty?

        m = c.messages.order(:created_at).first

        next if m.in_reply_to_id.nil?

        parent = Message.find(m.in_reply_to_id)

        # Delete weird conversation
        c.messages.update_all(conversation_id: parent.conversation.id)
        # c.delete

        # Recalculate in-reply-to
        parent.conversation.messages.each do |m|
          idx = m.conversation.messages.index(m)
          if idx > 0
            in_reply_to = m.conversation.messages[idx - 1]
            m.update_column(:in_reply_to_id, in_reply_to.id)
          end
        end

      end
    end

    # Delete any leftover empty conversations

    Conversation.find_in_batches do |cs|
      cs.each do |c|
        c.delete if c.messages.empty?
      end
    end


  end
end
