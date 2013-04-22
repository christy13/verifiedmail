class CreateMhashes < ActiveRecord::Migration
  def change
    create_table :mhashes do |t|
      t.integer :user_id
      t.string :hash

      t.timestamps
    end
  end
end
