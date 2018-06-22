module Harvest
  module Api
    class << self
      def client
        client_class = Class.new { include Client }
        client_class.new
      end
    end
  end
end
