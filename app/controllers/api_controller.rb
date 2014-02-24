class ApiController < ApplicationController
  skip_before_action :verify_authenticity_token
  respond_to :json

  rescue_from ActionController::ParameterMissing, with: :parameter_missing

  protected

  def parameter_missing(exception)
    render(
      json: {error: exception.message},
      status: :bad_request
    )
  end

end
