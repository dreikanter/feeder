errors = Error
  .where('file_name LIKE ?', '%_loader.rb')
  .select(:message)
  .distinct
  .pluck(:message)
  .map { |line| line.sub('error fetching feed: ', '') }
  .map { |line| line.split('; ', 2) }

errors = errors.each_with_object({}) do |item, result|
  error = item[0].gsub("'", '').to_s
  result[error] ||= []
  result[error] << item[1].split('; ', 2)[1]
end

puts(JSON.pretty_generate(errors))
