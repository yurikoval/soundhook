class Sound < ApplicationRecord
  validates_uniqueness_of :name
  validates_presence_of :name
  validates_presence_of :sound_file, if: :type_requires_sound
  has_attached_file :sound_file
  validates_attachment_content_type :sound_file, :content_type => /.*/

  before_save do
    self.hook_type ||= 'sound'
  end

private
  def type_requires_sound
    self.hook_type != 'youtube'
  end
end
