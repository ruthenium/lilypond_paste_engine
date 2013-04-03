class AddExpiresAtToPaste < ActiveRecord::Migration
  def change
    add_column :pastes, :expires_at, :datetime
  end
end
