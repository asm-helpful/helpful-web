require 'activerecord/uuid'

class BetaInvite < ActiveRecord::Base
  include ActiveRecord::UUID

  # invite_token - starts out null and is filled in when an invite is sent to the user that requested it
  # user_id      - starts out null and is filled in when an invited user creates an account (so we know they accepted)

  validates :email, format: {with: /@/}
end
