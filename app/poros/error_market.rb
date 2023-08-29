class ErrorMarket
  attr_reader :error_message,
              :status,
              :code

  def initialize
    @error_message = error_message
    @status = status
    @code = code
  end
end