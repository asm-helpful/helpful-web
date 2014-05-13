class RemoveFirstAndLastNameFromPerson < ActiveRecord::Migration
  def change
    Person.all.each do |person|
      if person.name.blank? && (person.first_name.present? || person.last_name.present?)
        person.name = [person.first_name, person.last_name].join(' ')
        person.save!
      end
    end

    remove_column :people, :first_name
    remove_column :people, :last_name
  end
end
