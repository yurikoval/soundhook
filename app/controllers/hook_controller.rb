require 'uri'
class HookController < ApplicationController
  after_action :send_sound
  skip_before_action :verify_authenticity_token

  def create
    if sound = Sound.find_by(name: params[:provider])
      @data = "#{sound.hook_type.camelize}Formatter"
        .safe_constantize
        .new(sound, params)
        .data
      render plain: "Soundhook received for #{params[:provider]}"
    else
      head :not_found
    end
  end

private

  def send_sound
    if @data
      ActionCable.server.broadcast 'messages', @data
    end
  end
end
