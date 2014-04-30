class AddFirstNameAndLastNameToPeople < ActiveRecord::Migration
  def change
    add_column :people, :first_name, :string
    add_column :people, :last_name, :string

    reversible do |dir|
      dir.up {
        for person in Person.all
          if person[:first_name].nil? && !person[:name].nil?
            names = person[:name].split(' ')
            person.update_attribute(:first_name, names[0])
            person.update_attribute(:last_name, Array(names[1..-1]).join(' '))
          end
        end
      }
    end
  end
end
