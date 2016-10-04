class HookController < ApplicationController
  def create
    render text: "Soundhook received for #{params[:provider]}"
  end
end
