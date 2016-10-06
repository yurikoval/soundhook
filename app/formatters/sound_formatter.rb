class SoundFormatter
  def initialize(sound, params = {})
    @sound = sound
    @params = params
  end

  def data
    {
      sound_url: @sound.sound_file.url,
      format: @sound.sound_file_content_type
    }
  end
end
