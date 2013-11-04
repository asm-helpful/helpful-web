class BetaInvitesController < ApplicationController
  # POST /beta_invites
  def create
    @beta_invite = BetaInvite.find_or_create_by(email: params[:beta_invite][:email].to_s)

    if @beta_invite.persisted?
      redirect_to root_url, notice: 'Awesome, thanks for your interest!'
    else
      redirect_to root_url, alert: "We're sorry, there was an error: #{@beta_invite.errors.full_messages.join(', ')}"
    end
  end

end
