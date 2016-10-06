class BaseFormatter
  FORMATTERS = %w(sound youtube zuora message).freeze
  def initialize(webhook, params = {})
    @webhook = webhook
    @params = params
  end

  def response
    "Soundhook received for #{@params[:provider]}."
  end

  def format
    :plain
  end
end
