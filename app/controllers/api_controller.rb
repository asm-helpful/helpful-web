class ApiController < ApplicationController

  respond_to :json

  before_action :authenticate_user!
  skip_before_action :verify_authenticity_token

  rescue_from ActionController::ParameterMissing, with: :parameter_missing

  protected

  def parameter_missing(exception)
    render(
      json: {error: exception.message},
      status: :bad_request
    )
  end

end
