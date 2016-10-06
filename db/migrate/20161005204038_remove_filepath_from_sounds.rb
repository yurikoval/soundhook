class RemoveFilepathFromSounds < ActiveRecord::Migration[5.0]
  def self.up
    remove_column :sounds, :filepath
  end

  def self.down
    add_column :sounds, :filepath, :string
  end
end
