class AddSoundFileToSounds < ActiveRecord::Migration[5.0]
  def self.up
    add_attachment :sounds, :sound_file
  end

  def self.down
    remove_attachment :sounds, :sound_file
  end
end
