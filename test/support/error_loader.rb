class ErrorLoader < BaseLoader
  protected

  def perform
    raise 'loader error'
  end
end
