require 'test_helper'

class BetaInvitesControllerTest < ActionController::TestCase

  def test_create_increments_beta_invite
    assert_difference('BetaInvite.count') do
      post :create, beta_invite: attributes_for(:beta_invite)
    end
  end

  def test_create_redirects_to_root
    post :create, beta_invite: attributes_for(:beta_invite)
    assert_redirected_to root_url
  end

  def test_create_sets_flash_notice
    post :create, beta_invite: attributes_for(:beta_invite)
    assert flash[:notice]
  end

  def test_create_ignores_duplicates
    email = 'email@example.com'
    create(:beta_invite, email: email)
    assert_no_difference('BetaInvite.count') do
      post :create, beta_invite: attributes_for(:beta_invite, email: email)
    end
  end

  def test_create_invalid_doesnt_save
    assert_no_difference('BetaInvite.count') do
      post :create, beta_invite: attributes_for(:beta_invite, email: 'invalid')
    end
  end

  def test_create_invalid_sets_flash_alert
    post :create, beta_invite: attributes_for(:beta_invite, email: 'invalid')
    assert flash[:alert]
  end

end
