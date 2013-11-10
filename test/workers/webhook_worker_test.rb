require 'test_helper'

class WebhookWorkerTest < ActiveSupport::TestCase
  
  def setup
    @subject = WebhookWorker.new
  end
  
  def test_perform
    skip
  end
  
end
