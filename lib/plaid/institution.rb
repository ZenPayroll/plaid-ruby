module Plaid
  class Institution
    class << self
      def all
        response = RestClient.get('institutions')
        { code: response.code, institutions: response.body }
      end
    end
  end
end
