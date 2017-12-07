class CreateTableDevices < Sequel::Migration
  def up
    create_table :triggers do
      primary_key :id
      column :device_id, Integer
      column :title, String
      column :key, String
      column :output, :jsonb
      column :created_at, :timestamp
      column :updated_at, :timestamp
    end
  end

  def down
    drop_table :triggers
  end
end