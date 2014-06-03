class InvitationCreatePolicy < Policy
  def initialize(account, user, invitation_membership)
    @account = account
    @user = user
    @invitation_membership = invitation_membership
  end

  def access?
    member? && allowed_role?
  end

  def member?
    membership.present?
  end

  def allowed_role?
    owner? || invited_agent?
  end

  def owner?
    membership.role == 'owner'
  end

  def invited_agent?
    @invitation_membership.role == 'agent'
  end

  def membership
    @account && @account.memberships.find_by(user_id: @user.id)
  end
end
