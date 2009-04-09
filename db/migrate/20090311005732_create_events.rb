class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.string  :title
      t.string  :theme
      t.integer :location_id
      t.integer :projected_cost
      t.integer :ticket_type_id
      t.text    :notes
      t.string  :when
      t.string  :picture_location
      t.text    :description
      t.boolean :public
      

      t.timestamps
    end
  end

  def self.down
    drop_table :events
  end
end
