class CreatePastes < ActiveRecord::Migration
  def change
    create_table :pastes do |t|
      t.text :lilypond_text
      t.boolean :hold, :null => false, :default => false
      t.string :visible_id, :limit => 6, :null => false

      t.timestamps
    end
  end
end
