require 'test_helper'

class ConversationTest < ActiveSupport::TestCase

  def test_valid
    assert build(:conversation).valid?
  end

  def test_open_by_default
    assert build(:conversation).open?
  end

  def test_archive
    conversation = create(:conversation)
    conversation.archive
    assert conversation.archived?
  end

  def test_class_open
    create(:conversation)
    create(:archived_conversation)
    assert Conversation.open {|conversation| conversation.open? }
  end

  def test_adds_the_correct_conversation_number_on_create_based_on_account_id
    account = create(:account)

    conversation_1 = create(:conversation, account: account)
    assert_equal 1, conversation_1.number

    conversation_2 = create(:conversation, account: account)
    assert_equal 2, conversation_2.number

    conversation_3 = create(:conversation)
    assert_equal 1, conversation_3.number
  end

end
