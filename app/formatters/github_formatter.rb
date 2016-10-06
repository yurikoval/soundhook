class GithubFormatter < BaseFormatter
  def data
    {
      type: 'git_master_modified',
      repository: @params[:respository][:name],
      sender_name: @params[:sender][:login],
      sender_img: @params[:sender][:avatar_url],
      commits: @params[:commits],
      sound_url: @webhook.sound_file.url,
      format: @webhook.sound_file_content_type
    }
  end
end
