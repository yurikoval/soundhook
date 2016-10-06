class MessageFormatter < BaseFormatter
  def data
    {
      type: 'message',
      msg: @params[:text],
      sound_url: @webhook.sound_file.url,
      format: @webhook.sound_file_content_type
    }
  end
end
