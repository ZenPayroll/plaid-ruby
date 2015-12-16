module Plaid
  class Institution
    class << self
      def all
        response = RestClient.get('institutions')
        { code: response.code, institutions: response.body }
      end

      def search(query)
        response = RestClient.get("institutions/search?q=#{CGI.escape(query)}")
        { code: response.code, suggestions: response.body }
      end
    end
  end
end
