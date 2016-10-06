class HookController < ApplicationController
  after_action :send_hook
  skip_before_filter :verify_authenticity_token
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
    @data = {
      type: 'youtube',
      name: params[:name],
      url: params[:url]
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
end
