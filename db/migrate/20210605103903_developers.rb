class Developers < ActiveRecord::Migration[6.1]
  def change
    create_table :developers do |t|
      t.string "full_name", :null => false
      t.string "email"
      t.string "mobile"
      t.integer "team_id"
      t.timestamps
    end
   add_foreign_key :developers, :teams, column: :team_id
  end
end
