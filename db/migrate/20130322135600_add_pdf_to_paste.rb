class AddPdfToPaste < ActiveRecord::Migration
  def change
    add_column :pastes, :pdf, :string
  end
end
