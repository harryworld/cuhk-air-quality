class CreatePoints < ActiveRecord::Migration
  def change
    create_table :points do |t|
      t.float :temperature
      t.float :pm25
      t.integer :group

      t.timestamps
    end
  end
end
