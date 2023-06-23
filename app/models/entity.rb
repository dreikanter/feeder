# TODO: Rename to FeedEntry, to be less generic
# TODO: Consider using ActiveModel::Attributes
class Entity
  extend Dry::Initializer

  option :uid
  option :content
  option :feed
end
