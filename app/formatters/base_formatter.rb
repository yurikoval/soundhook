class BaseFormatter
  FORMATTERS = %w(sound youtube zuora).freeze
  def initialize(sound, params = {})
    @sound = sound
    @params = params
  end

  def response
    "Soundhook received for #{@params[:provider]}."
  end

  def format
    :plain
  end
end
