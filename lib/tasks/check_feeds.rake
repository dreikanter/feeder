# Smoke-test all enabled feeds against live sources.
#
# Runs the full loader → processor → normalizer pipeline for every enabled
# feed without writing posts or touching the Freefeed API.
#
# Prerequisites:
#   1. A running PostgreSQL database (RAILS_ENV=development or test).
#   2. For nitter feeds: run `rake feeder:import_nitter_instances` first so
#      that ServiceInstance records exist.
#
# Usage:
#   bundle exec rake feeder:check              # check all enabled feeds
#   bundle exec rake feeder:check[feed-name]   # check one specific feed
#
namespace :feeder do
  desc "Smoke-test enabled feeds without posting (loader+processor+normalizer only)"
  task :check, [:feed_name] => :environment do |_task, args|
    FeedsConfiguration.sync

    feeds =
      if args[:feed_name].present?
        [Feed.enabled.find_by!(name: args[:feed_name])]
      else
        Feed.enabled.order(:name)
      end

    puts "\nChecking #{feeds.size} #{"feed".pluralize(feeds.size)}...\n\n"

    results = feeds.map do |feed|
      result = CheckFeed.call(feed)
      print_feed_result(result)
      result
    end

    print_summary(results)

    exit 1 if results.any? { |r| r.error_message }
  end
end

def print_feed_result(result)
  pipeline = "#{result.loader}/#{result.processor}/#{result.normalizer}"

  if result.error_message
    status = red("✗")
    detail = red("FAILED: #{result.error_message}")
  elsif result.entity_count.zero?
    status = yellow("⚠")
    detail = yellow("0 entities")
  else
    status = green("✓")
    parts = ["#{result.entity_count} #{"entity".pluralize(result.entity_count)}"]
    unless result.validation_error_tally.empty?
      tally_str = result.validation_error_tally.map { |k, v| "#{k}: #{v}" }.join(", ")
      parts << dim("[#{tally_str}]")
    end
    detail = parts.join("  ")
  end

  puts "  #{status}  #{result.feed_name.ljust(30)} #{dim(pipeline.ljust(36))} #{detail}"
end

def print_summary(results)
  ok = results.count { |r| r.error_message.nil? && r.entity_count.positive? }
  warned = results.count { |r| r.error_message.nil? && r.entity_count.zero? }
  failed = results.count { |r| r.error_message }

  puts "\n#{"─" * 78}\n"
  parts = ["Checked #{results.size} #{"feed".pluralize(results.size)}:"]
  parts << green("#{ok} ok") if ok.positive?
  parts << yellow("#{warned} warned") if warned.positive?
  parts << red("#{failed} failed") if failed.positive?
  puts parts.join("  ")

  if failed.positive?
    puts "\nFailed feeds:"
    results.select { |r| r.error_message }.each do |r|
      puts "  #{red(r.feed_name)}: #{r.error_message}"
    end
  end

  puts
end

def green(str) = colorize(str, 32)
def yellow(str) = colorize(str, 33)
def red(str) = colorize(str, 31)
def dim(str) = colorize(str, 2)

def colorize(str, code)
  $stdout.tty? ? "\e[#{code}m#{str}\e[0m" : str
end
