module HttpClient
  def http
    HTTP.use(:request_tracking)
  end
end
