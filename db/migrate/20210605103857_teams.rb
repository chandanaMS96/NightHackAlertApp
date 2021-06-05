class Teams < ActiveRecord::Migration[6.1]
  def change
  	create_table :teams do |t|
      t.string "name", :null => false
      t.string "dept_name", :null => false 
      t.timestamps
    end
  end
end
