class AsmSignupPromotionWorker
  include Sidekiq::Worker

  def perform(account_id)
    return if ENV['ASM_SIGNUP_BOUNTY'].nil?

    @account = Account.find(account_id)
    if @account.asm_signup_promotion_completed_at.nil? &&
       @account.memberships.size > 1 && # 1st member is the user that signed up
       @account.messages.count > 3 # First 3 messages are auto generated

      client = AsmClient.new
      client.post(
        "/orgs/#{ENV['ASM_SIGNUP_BOUNTY']}/awards",
        email: @account.email,
        reason: 'signup promotion'
      )

      @account.update!(asm_signup_promotion_completed_at: Time.now)
    end
  end
end
