class CreateDataPoint
  include Callee

  param :series_name, type: proc(&:to_s)
  param :details, default: proc { {} }
  option :created_at, options: true, default: -> { nil }

  def call
    DataPoint.create(
      series_id: series.id,
      details: details,
      created_at: created_at
    )
  end

  def series
    DataPointSeries.find_or_create_by(name: series_name)
  end
end
