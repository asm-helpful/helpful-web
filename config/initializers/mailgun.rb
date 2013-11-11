require 'mailgun'

ActionMailer::Base.add_delivery_method(:mailgun, Mailgun::DeliveryMethod)
