class Sparkline < ApplicationRecord
  belongs_to :feed

  validates :data, presence: true

  def points
    (data["points"] || []).map { |point| with_parsed_date(point) }
  end

  private

  def with_parsed_date(point)
    point["date"] = Date.parse(point["date"])
    point
  end
end
