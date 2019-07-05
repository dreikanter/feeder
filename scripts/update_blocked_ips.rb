started_at = Time.new.utc

API_URL = 'https://reestr.rublacklist.net/api/v2/ips/json'.freeze

Rails.logger.info('fetching blocked ips...')
content = RestClient.get(API_URL).body
ips = JSON.parse(content)
Rails.logger.info("total ips: #{ips.count}")

valid_ips = ips.select do |ip|
  begin
    IPAddr.new(ip)
    ip
  rescue IPAddr::InvalidAddressError => e
    Rails.logger.error(e)
  end
end

bad_ips_count = ips.length - valid_ips.length
Rails.logger.info("invalid ips: #{bad_ips_count}") if bad_ips_count.positive?

threshold = BlockedIP.order(updated_at: :desc).first.try(:updated_at)
prev_blocked_count = BlockedIP.count

values = valid_ips.map { |ip| "('#{ip}')" }.join(',')

query = "INSERT INTO blocked_ips (ip) VALUES #{values} " \
        "ON CONFLICT (ip) DO UPDATE SET updated_at = DEFAULT"

Rails.logger.info('updating db...')

begin
  ActiveRecord::Base.connection.exec_query(query)
rescue => e
  Rails.logger.error(e.message.to_s[0, 1000])
  exit
end

unblocked = BlockedIP.where('updated_at <= ?', threshold)
unblocked_count = unblocked.count

if unblocked_count.positive?
  Rails.logger.info("new unblocked ips: #{unblocked_count}")
  DataPoint.create_rkn_unblock(count: unblocked_count)
  unblocked.delete_all
end

blocked_count = BlockedIP.count
new_blocked_count = [blocked_count - prev_blocked_count, 0].max

if new_blocked_count.positive?
  Rails.logger.info("new blocked ips: #{new_blocked_count}")
  DataPoint.create_rkn_block(count: new_blocked_count)
end

Rails.logger.info("overall blocked ips: #{blocked_count}")

DataPoint.create_pull(
  feed_name: 'update_blocked_ips',
  duration: Time.new.utc - started_at,
  new_blocked_count: new_blocked_count,
  new_unblocked_count: unblocked_count,
  blocked_count: blocked_count
)
