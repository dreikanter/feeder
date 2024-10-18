class Permission < ApplicationRecord
  ADMIN = "admin"

  AVAILABLE_NAMES = [
    ADMIN
  ].freeze

  belongs_to :user

  validates :name, inclusion: AVAILABLE_NAMES
end
