class SyncSchemaWithProduction < ActiveRecord::Migration
  def change
    execute 'CREATE EXTENSION IF NOT EXISTS pg_stat_statements'

    unless index_exists?(:conversations, :account_id)
      add_index :conversations, :account_id
    end
  end
end
