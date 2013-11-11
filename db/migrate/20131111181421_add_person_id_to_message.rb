class AddPersonIdToMessage < ActiveRecord::Migration
  def up
    Message.where(from: nil).delete_all

    add_column :messages, :person_id, :uuid

    Message.all.each do |message|
      person = Person.create(email: message.from)
      message.update_attribute(:person_id, person.id)
    end

    change_column :messages, :person_id, :uuid, :null => false

    remove_column :messages, :from
  end
end
