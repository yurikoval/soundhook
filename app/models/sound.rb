class Sound < ApplicationRecord
  validates_uniqueness_of :name
  has_attached_file :sound_file
  validates_attachment_content_type :sound_file, :content_type => /.*/
end
