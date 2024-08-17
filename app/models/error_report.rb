class ErrorReport < ApplicationRecord
  belongs_to :target, polymorphic: true, optional: true
end
