module Service
  class CreateDataPoint
    extend Dry::Initializer

    param :series_name, type: proc(&:to_s)
    param :details, default: proc { {} }

    def self.call(series_name, details = {})
      new(series_name, details).call
    end

    def call
      DataPoint.create(series_id: series.id, details: details)
    end

    def series
      DataPointSeries.find_or_create_by(name: series_name)
    end
  end
end
