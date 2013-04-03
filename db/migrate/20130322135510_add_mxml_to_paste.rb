class AddMxmlToPaste < ActiveRecord::Migration
  def change
    add_column :pastes, :mxml, :string
  end
end
