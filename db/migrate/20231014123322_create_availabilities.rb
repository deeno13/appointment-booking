class CreateAvailabilities < ActiveRecord::Migration[7.1]
  def change
    create_table :availabilities do |t|
      t.references :trainer, null: false, foreign_key: true
      t.integer :day_of_week
      t.datetime :start_time
      t.datetime :end_time

      t.timestamps
    end
  end
end
