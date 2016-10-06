class SoundFormatter < BaseFormatter
  def data
    {
      type: :sound,
      sound_url: @sound.sound_file.url,
      format: @sound.sound_file_content_type
    }
  end
end
