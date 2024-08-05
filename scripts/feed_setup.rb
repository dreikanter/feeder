# TBD: Refactor script structure if/after the flow will get stabilized
# :reek:DuplicateMethodCall:
# :reek:TooManyStatements
class FeedSetup
  include ActionView::Helpers::NumberHelper

  def perform
    feed_name = ARGV[0]

    unless feed_name
      puts "Specify feed name to setup"
      exit 1
    end

    puts "feed name: #{feed_name}"

    config_path = Rails.root.join(FeedsConfiguration::DEFAULT_PATH)
    config_data = YAML.load_file(config_path).map { FeedSanitizer.call(**_1.symbolize_keys) }

    feed = config_data.find { _1[:name] == feed_name }

    if feed
      puts "feed configuration:"
      puts JSON.pretty_generate(feed)
    else
      puts "configuration not found"
      exit 1
    end

    feed = feed[:attributes]

    touch_or_create_file(subject: "normalizer", path: "app/normalizers/#{feed[:normalizer]}_normalizer.rb")
    touch_or_create_file(subject: "normalizer spec", path: "spec/normalizers/#{feed[:normalizer]}_normalizer_spec.rb")
    touch_or_create_file(subject: "processor", path: "app/processors/#{feed[:processor]}_processor.rb")
    touch_or_create_file(subject: "processor spec", path: "spec/processors/#{feed[:processor]}_processor_spec.rb")

    feed_url = feed[:url]

    if feed_url.present?
      puts "downloading feed content (#{feed_url})"
      content = HTTP.get(feed_url).to_s
      touch_or_create_file(subject: "feed fixture", path: "spec/fixtures/files/feeds/#{feed_name}/feed.xml", content: content)
    else
      puts "feed URL not defined, skipping the fixturing"
    end
  end

  private

  def touch_or_create_file(subject:, path:, content: nil)
    if path.blank?
      puts "#{subject} path undefined"
      return
    end

    path = Rails.root.join(path)

    if File.exist?(path)
      puts "#{subject}: #{path} (exists)"
    else
      puts "#{subject}: #{path} (will be created)"
      FileUtils.mkdir_p(File.dirname(path))
      FileUtils.touch(path)
    end

    if content.present?
      if File.read(path).blank?
        puts "writing content (length: #{number_to_human_size(content.to_s.length)})"
        File.write(path, content)
      else
        puts "ignoring content (file not empty)"
      end
    end

    true
  end
end
