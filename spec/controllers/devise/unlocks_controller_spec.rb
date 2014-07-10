require 'spec_helper'

describe Devise::UnlocksController do

  it "GET /new is successful" do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    get :new
    expect(response).to be_success
  end

end
