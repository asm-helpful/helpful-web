class Policy

  class NotAuthorized < StandardError
  end

  def access?
    false
  end

  def authorize!
    access? || raise(NotAuthorized)
  end

end
