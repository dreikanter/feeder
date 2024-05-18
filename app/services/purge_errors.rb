class PurgeErrors
  include Callee

  option :before

  def call
    Error.where(created_at: ...before).delete_all
  end
end
