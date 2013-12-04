# Picks the best nickname for a person given the information the system knows
# about them.
class Nicknamer

  def initialize(person)
    @person = person
  end

  def nickname
    @person.name || @person.twitter || @person.email
  end

end
