# frozen_string_literal: true

module FileHelpers
  FILE_FIXTURES_PATH =
    File.join(File.expand_path('..', __dir__), 'fixtures', 'files')

  def file_fixture(path)
    File.open(File.join(FILE_FIXTURES_PATH, path))
  end
end
