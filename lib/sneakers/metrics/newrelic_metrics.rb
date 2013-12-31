module Sneakers
  module Metrics
    class NewrelicMetrics
      def initialize(conn)
        @connection = conn
      end

      def increment(metric)
        record_stat metric, 1
      end

      def record_stat(metric, num)
        stats(metric).record_data_point(num)
      rescue Exception => e
        puts "NewrelicMetrics#record_stat: #{e}"
      end

      def timing(metric, &block)
        start = Time.now
        block.call
        record_stat(metric, ((Time.now - start)*1000).floor)
      end

      def stats(metric)
        metric.gsub! "\.", "\/"
        @connection::Agent.get_stats("Custom/#{metric}")
      end

    end
  end
end

