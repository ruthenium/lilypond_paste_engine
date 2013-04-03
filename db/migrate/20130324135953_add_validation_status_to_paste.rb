class AddValidationStatusToPaste < ActiveRecord::Migration
  def change
    add_column :pastes, :processed, :boolean, :null => false, :default => false
    add_column :pastes, :proc_success, :boolean, :null => false, :default => false
    add_column :pastes, :status, :text
  end
end
