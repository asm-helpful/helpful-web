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

  def update
    self.resource = resource_class.accept_invitation!(update_resource_params)

    account = resource.primary_owned_account
    person = Person.create(
      account:    account,
      user:       resource,
      name:       params[:user][:name],
      username:   params[:person][:username],
      email:      resource.email
    )

    if resource.errors.empty?
      flash_message = resource.active_for_authentication? ? :updated : :updated_not_active
      set_flash_message :notice, flash_message
      sign_in(resource_name, resource)
      respond_with resource, :location => after_accept_path_for(resource)
    else
      respond_with_navigational(resource){ render :edit }
    end
  end

end
