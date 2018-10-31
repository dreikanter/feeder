class Success < Result
  def initialize(payload = nil)
    super(success: true, payload: payload)
  end
end
