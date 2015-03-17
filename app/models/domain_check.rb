class DomainCheck < ActiveRecord::Base

  class SpfQueryError < StandardError; end

  HELPFUL_DOMAIN = 'helpful.io'

  def self.check!(domain)
    obj = new(domain: domain)
    obj.check!
    obj.save!
    obj
  end

  def self.find_latest_for(domain)
    order(:created_at).reverse_order.find_by(domain: domain)
  end

  def check!
    self.spf_valid = self.class.check_spf_of!(domain)
  end

private

  def self.check_spf_of!(domain)
    record = SPF::Query::Record.query(domain)
    raise SpfQueryError if record.nil?
    record.mechanisms.any? do |m|
      m.value == HELPFUL_DOMAIN
    end
  end

end
