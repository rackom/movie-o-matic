class CreateScreenings < ActiveRecord::Migration
  def self.up
    create_table :screenings do |t|
      t.references :movie
      t.float :time_before_screening
      t.integer :seats_taken
      t.integer :seats_total

      t.timestamps
    end
  end

  def self.down
    drop_table :screenings
  end
end
