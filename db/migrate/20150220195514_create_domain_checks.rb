class CreateDomainChecks < ActiveRecord::Migration
  def change
    create_table :domain_checks, id: :uuid do |t|
      t.string :domain
      t.boolean :spf_valid, null: true, default: false
      t.timestamps null: false
    end
  end
end
