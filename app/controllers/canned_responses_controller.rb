class CannedResponsesController < ApplicationController
  before_action :authenticate_user!
  before_action :find_account!

  def index
    @canned_responses = @account.canned_responses
  end

  def new
    @canned_response = @account.canned_responses.new
  end

  def create
    @canned_response = @account.canned_responses.new(canned_response_params)

    if @canned_response.save
      redirect_to account_canned_responses_path(@account)
    else
      render :new
    end
  end

  def edit
    @canned_response = @account.canned_responses.find(params[:id])
  end

  def update
    @canned_response = @account.canned_responses.find(params[:id])

    if @canned_response.update(canned_response_params)
      redirect_to account_canned_responses_path(@account)
    else
      render :edit
    end
  end

  def destroy
    @canned_response = @account.canned_responses.find(params[:id])
    @canned_response.destroy
    redirect_to account_canned_responses_path(@account)
  end

  def find_account!
    @account = Account.friendly.find_by!(slug: params.fetch(:account_id))
    authorize! AccountReadPolicy.new(@account, current_user)
  end

  def canned_response_params
    params.require(:canned_response).permit(:key, :message)
  end
end
