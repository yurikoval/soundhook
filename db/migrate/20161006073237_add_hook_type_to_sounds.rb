class AddHookTypeToSounds < ActiveRecord::Migration[5.0]
  def change
    add_column :sounds, :hook_type, :string
  end
end
