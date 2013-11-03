require 'test_helper'

describe BetaInvitesController do
  test "should create beta_invite" do
    assert_difference('BetaInvite.count') do
      post :create, beta_invite: { email: 'supportfoo@example.com' }
    end

    assert_redirected_to root_url
    assert_equal 'Awesome, thanks for your interest!', flash[:notice]
  end

  test "should ignore a duplicate" do
    email = 'supportfoo@example.com'
    BetaInvite.create!(email: email)
    assert_no_difference('BetaInvite.count') do
      post :create, beta_invite: { email: email }
    end

    assert_redirected_to root_url
    assert_equal 'Awesome, thanks for your interest!', flash[:notice]
  end

  test "should report a format error in the email" do
    email = 'supportfoo'
    assert_no_difference('BetaInvite.count') do
      post :create, beta_invite: { email: email }
    end

    assert_redirected_to root_url
    assert_match /Email is invalid/, flash[:alert]
  end
end
