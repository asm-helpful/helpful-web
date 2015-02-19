require 'spec_helper'

describe MessageMailman do
  describe '#deliver' do
    it 'delivers a message to each recipient' do
      message = double('Message')
      message_mailman = double('MessageMailman')
      recipients = [double('Person')]

      expect(MessageMailman).to receive(:new).with(message, recipients) { message_mailman }
      expect(message_mailman).to receive(:deliver)

      MessageMailman.deliver(message, recipients)
    end
  end

  describe '#deliver' do
    it 'calls #deliver_to for each recipient' do
      recipients = [double('Patrick'), double('Chris')]
      message_mailman = MessageMailman.new(double('Message'), recipients)
      allow(message_mailman).to receive(:notify?) { true }

      recipients.each do |recipient|
        expect(message_mailman).to receive(:deliver_to).with(recipient)
      end

      message_mailman.deliver
    end

    it 'filters out users who do not wish to receive notifications' do
      patrick = double('Patrick')
      chris = double('Chris')
      recipients = [patrick, chris]

      message_mailman = MessageMailman.new(double('Message'), recipients)
      allow(message_mailman).to receive(:notify?) { |person| person == patrick }

      expect(message_mailman).to receive(:deliver_to).with(patrick)

      message_mailman.deliver
    end
  end

  describe '#deliver_to' do
    it 'sends an async message mailer email' do
      message = double('Message', id: 1)
      recipient = double('Recipient', id: 2)
      message_mailman = MessageMailman.new(message, [recipient])

      expect(MessageMailer).to receive(:delay) { MessageMailer }
      expect(MessageMailer).to receive(:created).with(1, 2)

      message_mailman.deliver_to(recipient)
    end
  end
end
