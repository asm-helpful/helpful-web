class TwitterValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value =~ /\A[A-z0-9_]{1,15}\z/
      record.errors[attribute] << (options[:message] || 'is not a valid Twitter username')
    end
  end
end