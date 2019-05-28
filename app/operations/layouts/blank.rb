module Operations
  module Layouts
    class Blank < Operations::Base
      def call
        {
          html: '',
          layout: 'application',
          locals: { title: '' }
        }
      end
    end
  end
end
