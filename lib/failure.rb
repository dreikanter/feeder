class Failure < Result
  def initialize(payload = nil)
    super(success: false, payload: payload)
  end
end
