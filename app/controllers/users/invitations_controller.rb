class Users::InvitationsController < Devise::InvitationsController
  before_filter :find_account!, only: [:create]

  def create
    if existing_user = User.find_by(email: params[:user][:email])
      @user = existing_user
    else
      @user = invite_resource
    end

    @membership = Membership.new(
      role: params.fetch(:membership_role),
      user: @user,
      account: @account
    )

    @person = Person.new
    @plans = BillingPlan.order('price ASC')

    authorize! InvitationCreatePolicy.new(@account, current_user, @membership)

    if @membership.save
      respond_with @user do |format|
        format.html do
          set_flash_message :notice, :send_instructions, email: @user.email if @user.invitation_sent_at
          redirect_to edit_account_path(@account)
        end

        format.json
      end
    else
      respond_with @user do |format|
        format.html { render 'accounts/edit' }
        format.json
      end
    end
  end

  def update
    self.resource = resource_class.accept_invitation!(update_resource_params)

    resource.accounts.each do |account|
      Person.create(
        account:    account,
        user:       resource,
        name:       params[:person][:name],
        username:   params[:person][:username],
        email:      resource.email
      )
    end

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
