module Plaid
  class LongtailInstitution
    class << self
      def get(count=50, offset=0)
        parse_response(RestClient.post('institutions/longtail',
          count: count,
          offset: offset)
        )
      end

      private

      def parse_response(response)
        parsed = response.body
        case response.code
        when 200
          { code: response.code, total: parsed.total_count, institutions: parsed.results}
        else
          { code: response.code, error: parsed }
        end
      end
    end
  end
end
