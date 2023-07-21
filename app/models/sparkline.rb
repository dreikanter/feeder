class Sparkline < ApplicationRecord
  belongs_to :feed

  validates :data, presence: true

  def points
    (data["points"] || []).map do |point|
      point.merge("date" => Date.parse(point["date"]))
    end
  end
end
