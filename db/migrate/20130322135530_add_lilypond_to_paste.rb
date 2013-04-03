class AddLilypondToPaste < ActiveRecord::Migration
  def change
    add_column :pastes, :lilypond, :string
  end
end
