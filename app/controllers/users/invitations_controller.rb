class Users::InvitationsController < Devise::InvitationsController
  before_filter :find_account!

  def create
    @user = invite_resource
    @person = Person.new
    @plans = BillingPlan.order('price ASC')

    @membership = Membership.new(
      role: params.fetch(:membership_role),
      user: @user,
      account: @account
    )

    if @membership.save
      if @user.invitation_sent_at
        set_flash_message :notice, :send_instructions, email: @user.email
      end

      redirect_to edit_account_path(@account)
    else
      render 'accounts/edit'
    end
  end

  def update
    self.resource = resource_class.accept_invitation!(update_resource_params)

    person = Person.create(
      account:    @account,
      user:       resource,
      first_name: params[:user][:first_name],
      last_name:  params[:user][:last_name],
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

  def find_account!
    @account = Account.find_by!(slug: params.fetch(:account_id))
    authorize! AccountReadPolicy.new(@account, current_user)
  end
end
