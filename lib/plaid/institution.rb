module Plaid
  class Institution
    class << self
      def all(count=50, offset=0)
        response = RestClient.post('institutions/all',
          count: count,
          offset: offset
        )

        parse_response(response)
      end

      def search(query)
        response = RestClient.get("institutions/all/search?q=#{CGI.escape(query)}")
        { code: response.code, suggestions: response.body }
      end

      def parse_response(response)
        parsed = response.body
        case response.code
        when 200
          { code: response.code, total: parsed['total_count'], institutions: parsed['results']}
        else
          { code: response.code, error: parsed }
        end
      end
    end
  end
end
