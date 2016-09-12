SEQUEL_MIGRATION = %{
Sequel.migration do
  up do

  end

  down do

  end
end
}.strip.freeze

MIGRATIONS_PATH = File.expand_path('../../../db/migrations', __FILE__).freeze

require 'fileutils'

namespace :gen do
  desc 'Generate a timestamped, empty Sequel migration.'
  task :migration, :name do |_, args|
    def file_name(name, time)
      File.join(MIGRATIONS_PATH, "#{time}_#{name}.rb")
    end

    def create_migration(path)
      FileUtils.mkdir_p(MIGRATIONS_PATH)
      File.open(path, 'wt') { |f| f.write(SEQUEL_MIGRATION) }
      puts path
    end

    abort 'Migration name not specified' if args[:name].nil?
    create_migration(file_name(args[:name], Time.now.to_i))
  end
end
