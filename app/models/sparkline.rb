class Sparkline < ApplicationRecord
  belongs_to :feed

  validates :data, presence: true

  def points
    (data["points"] || []).map { parse_date(_1) }
  end

  private

  def parse_date(point)
    point.merge("date" => Date.parse(point["date"]))
  end
end
