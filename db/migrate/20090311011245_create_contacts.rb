class CreateContacts < ActiveRecord::Migration
  def self.up
    create_table :contacts do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.integer :location_id
      t.text :notes

      t.timestamps
    end
  end

  def self.down
    drop_table :contacts
  end
end
