class BaseFormatter
  FORMATTERS = %w(sound youtube zuora message github).freeze
  def initialize(webhook, params = {})
    @webhook = webhook
    @params = params
  end

  def response
    "Sent #{@params[:provider]}. to Billboard"
  end

  def format
    :plain
  end
end
