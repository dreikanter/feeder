# TODO: Consider calling UpdateFeeds from elsewhere
require_relative '../../app/enums/feed_status'
require_relative '../../app/models/application_record'
require_relative '../../app/models/feed'
require_relative '../../app/services/feed_sanitizer'
require_relative '../../app/services/update_feeds'

UpdateFeeds.call
