require 'spec_helper'

describe MessageMailman do
  describe '#deliver' do
    it 'delivers a message to each recipient' do
      message = double('Message')
      message_mailman = double('MessageMailman')
      recipients = [double('Person')]

      expect(MessageMailman).to receive(:new).with(message) { message_mailman }
      expect(message_mailman).to receive(:deliver_to_each).with(recipients)

      MessageMailman.deliver(message, recipients)
    end
  end

  describe '#deliver_to_each' do
    it 'calls #deliver_to for each recipient' do
      message_mailman = MessageMailman.new(double('Message'))
      recipients = [double('Patrick'), double('Chris')]

      recipients.each do |recipient|
        expect(message_mailman).to receive(:deliver_to).with(recipient)
      end

      message_mailman.deliver_to_each(recipients)
    end
  end

  describe '#deliver_to' do
    it 'sends an async message mailer email' do
      message = double('Message', id: 1)
      recipient = double('Recipient', id: 2)
      message_mailman = MessageMailman.new(message)

      expect(MessageMailer).to receive(:delay) { MessageMailer }
      expect(MessageMailer).to receive(:created).with(1, 2)

      message_mailman.deliver_to(recipient)
    end
  end
end
