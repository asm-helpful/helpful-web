module NicknameHelper

  def nickname(person)
    Nicknamer.new(person).nickname
  end

end
