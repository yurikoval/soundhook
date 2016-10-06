require 'uri'
class HookController < ApplicationController
  after_action :send_hook
  skip_before_action :verify_authenticity_token
  def create
    if sound = Sound.find_by(name: params[:provider])
      @data = {
        sound_url: sound.sound_file.url,
        format: sound.sound_file_content_type
      }
      render plain: "Soundhook received for #{params[:provider]}"
    else
      head :not_found
    end
  end

  def youtube
    url = extract_youtube_id(params[:text])
    @data = {
      type: 'youtube',
      name: params[:user_name],
      url: url,
    }
    head :ok
  end

private
  def send_hook
    @data[:type] ||= :sound
    if @data
      ActionCable.server.broadcast 'messages', @data
    end
  end

  def extract_youtube_id(url)
    URI(url).path[1..-1] rescue 'dQw4w9WgXcQ'
  end
end
