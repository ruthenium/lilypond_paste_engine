class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.integer :paste_id
      t.string :png

      t.timestamps
    end
  end
end
