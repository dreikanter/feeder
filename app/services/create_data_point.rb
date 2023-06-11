class CreateDataPoint
  def self.call(series_name, created_at: nil, details: {})
    DataPoint.create(
      created_at: created_at,
      details: details,
      series: DataPointSeries.find_or_create_by(name: series_name)
    )
  end
end
