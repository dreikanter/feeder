module Operations
  module Updates
    class Index < Operations::Base
      def call
        {
          json: {
            updates: updates,
            meta: meta
          }
        }
      end

      private

      def updates
        data_points.map { |dp| dp.details.merge(created_at: dp.created_at) }
      end

      def data_points
        return data_points_scope unless feed_name
        data_points_scope.where("details->>'feed_name' = ?", feed_name)
      end

      def data_points_scope
        DataPoint
          .for('pull')
          .where("(details->>'posts_count')::int > ?", 0)
          .recent
      end

      def meta
        {
          feed_name: feed_name
        }
      end

      def feed_name
        params[:feed_name]
      end
    end
  end
end
