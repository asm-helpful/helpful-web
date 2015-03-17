class DomainCheckWorker
  include Sidekiq::Worker

  def perform(account_id)
    @account = Account.find(account_id)
    if @account.forwarding_domain.present?
      DomainCheck.check!(@account.forwarding_domain)
    end 
  end
end
