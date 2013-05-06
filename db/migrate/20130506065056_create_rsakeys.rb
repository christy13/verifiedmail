class CreateRsakeys < ActiveRecord::Migration
  def change
    create_table :rsakeys do |t|
      t.string :public_key
      t.string :e_private_key
      t.integer :user_id

      t.timestamps
    end
  end
end
