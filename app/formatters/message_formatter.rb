class MessageFormatter < BaseFormatter
  def data
    {
      type: 'message',
      msg: @params[:text],
      username: @params[:user_name],
      sound_url: @webhook.sound_file.url,
      format: @webhook.sound_file_content_type
    }
  end

  def response
    "Sent #{@params[:provider]} to Billboard: #{@params[:text]}"
  end
end
