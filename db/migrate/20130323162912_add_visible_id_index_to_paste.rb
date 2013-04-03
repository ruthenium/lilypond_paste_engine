class AddVisibleIdIndexToPaste < ActiveRecord::Migration
  def change
    #add_column :pastes, :visible_id, :string, :limit => 6, :null => false, :default => 'ffffff'
    add_index :pastes, :visible_id, :unique => true
  end
end
