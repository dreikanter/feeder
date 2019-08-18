class RknAlertsProcessor < BaseProcessor
  def call
    save_current_status if first_run?
    return [] if first_run? || nothing_changed?
    save_current_status
    [[nil, payload]]
  end

  private

  def payload
    {
      total_count: freefeed_ips.count,
      blocked: recently_blocked,
      unblocked: recently_unblocked
    }
  end

  def prev_status
    @prev_status ||=
      DataPoint.for(:rkn).order(created_at: :desc).first.try(:details)
  end

  def current_status
    @current_status ||=
      freefeed_ips.map { |ip| [ip, ZapretFetcher.call(ip)] }.to_h
  end

  def freefeed_ips
    @freefeed_ips ||= FreefeedIpsFetcher.call
  end

  def recently_blocked
    freefeed_ips.select { |ip| current_status[ip] && !prev_status[ip] }
  end

  def recently_unblocked
    freefeed_ips.select { |ip| !current_status[ip] && prev_status[ip] }
  end

  def save_current_status
    DataPoint.for(:rkn).destroy_all
    CreateDataPoint.call(:rkn, current_status)
  end

  def first_run?
    !prev_status
  end

  def nothing_changed?
    recently_blocked.empty? && recently_unblocked.empty?
  end
end
