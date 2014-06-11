class PersonSerializer < BaseSerializer
  attributes :name, :email, :nickname

  def nickname
    Nicknamer.new(object).nickname
  end
end
