module Plaid
  class Institution
    class << self
      def all
        response = rest_get('institutions/')
        # TODO: Do these need response codes? It depends on how we decide to handle
        # error codes..
        { code: response.code, institutions: JSON.parse(response) }
      end

      def get(id)
        response = rest_get('institutions/', id)
        { code: response.code, institution: JSON.parse(response) }
      end

      private

      def rest_get(path, id = nil)
        RestClient.get(Plaid.base_url + path + id.to_s)
      end
    end
  end
end
