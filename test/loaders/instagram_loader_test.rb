require 'test_helper'

module Loaders
  class InstagramLoaderTest < Minitest::Test
    def subject
      Loaders::InstagramLoader
    end

    def create_feed
      create(:feed, options: { instagram_user: 'dreikanter' })
    end

    EXPECTED_OBJECT = { 'mango' => 'banana' }.freeze

    def with_sample_node_script
      Tempfile.create(subject.name.demodulize) do |script_file|
        script_file.write("console.log(#{EXPECTED_OBJECT.to_json.dump})")
        script_file.close
        yield script_file.path
      end
    end

    def test_node_available
      refute(`which node`.blank?)
    end

    def test_with_sample_node_script
      with_sample_node_script do |script_path|
        output = `node #{script_path}`.strip
        result = JSON.parse(output)
        assert_equal(EXPECTED_OBJECT, result)
        return
      end
      raise 'block should be executed'
    end

    def test_execute_script
      with_sample_node_script do |script_path|
        result = subject.call(create_feed, script_path: script_path)
        assert(result.success?)
        assert_equal(EXPECTED_OBJECT, result.value!)
      end
    end

    def test_require_instagram_user_option
      feed = create(:feed, options: {})
      with_sample_node_script do |script_path|
        result = subject.call(feed, script_path: script_path)
        assert(result.failure?)
      end
    end
  end
end
