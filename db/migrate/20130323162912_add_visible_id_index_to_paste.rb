class AddVisibleIdIndexToPaste < ActiveRecord::Migration
  def change
    add_index :pastes, :visible_id, :unique => true
  end
end
