class Sparkline < ApplicationRecord
  belongs_to :feed

  validates :data, presence: true
end
