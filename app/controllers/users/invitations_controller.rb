class Users::InvitationsController < Devise::InvitationsController

  # POST /resource/invitation
  def create
    self.resource = invite_resource

    account = current_user.primary_owned_account
    account.memberships.create(role: params.fetch(:membership_role), user: resource)

    if resource.errors.empty?
      set_flash_message :notice, :send_instructions, :email => self.resource.email if self.resource.invitation_sent_at
      respond_with resource, :location => edit_account_path(account)
    else
      respond_with_navigational(resource) { render :new }
    end
  end

end
