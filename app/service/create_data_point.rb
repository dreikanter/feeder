module Service
  class CreateDataPoint
    include Callee

    param :series_name, type: proc(&:to_s)
    param :details, default: proc { {} }

    def call
      DataPoint.create(series_id: series.id, details: details)
    end

    def series
      DataPointSeries.find_or_create_by(name: series_name)
    end
  end
end
