class SoundFormatter < BaseFormatter
  def data
    {
      type: :sound,
      sound_url: @webhook.sound_file.url,
      format: @webhook.sound_file_content_type
    }
  end
end
