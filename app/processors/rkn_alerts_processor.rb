module Processors
  class RknAlertsProcessor < Processors::Base
    def call
      persist_blocked_ips
      drop_unblocked_ips
      return [] if blocked.empty? && unblocked.empty?
      [[nil, { blocked: blocked, unblocked: unblocked }]]
    end

    private

    def persist_blocked_ips
      blocked.each { |ip| DataPoint.create_blocked(ip: ip) }
    end

    def drop_unblocked_ips
      return if unblocked.empty?
      list = unblocked.map { |ip| "'#{ip}'" }.join(',')
      DataPoint.where("details->>'ip' IN (#{list})").destroy_all
    end

    def blocked
      @blocked ||= currently_blocked - already_blocked
    end

    def unblocked
      @unblocked ||= already_blocked - currently_blocked
    end

    def currently_blocked
      @currently_blocked ||= Service::FreefeedIpsFetcher.call.select do |ip|
        Service::ZapretFetcher.call(ip)
      end
    end

    def already_blocked
      @already_blocked ||= DataPoint.for(:blocked).map { |dp| dp.details['ip'] }
    end
  end
end
