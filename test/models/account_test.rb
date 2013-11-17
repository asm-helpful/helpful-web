require 'test_helper'

class AccountTest < ActiveSupport::TestCase

  def test_valid
    assert build(:account).valid?
  end

  def test_unique_slug
    create(:account, name: 'unique', slug: 'unique')
    account = build(:account, name: 'unique', slug: 'unique')
    assert_raises(ActiveRecord::RecordNotUnique) do
      account.save
    end
  end

end
