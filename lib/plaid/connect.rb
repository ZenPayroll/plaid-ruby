module Plaid
  class Connect
    class << self
      def get(access_token)
        parse_response(post('connect/get', access_token: access_token))
      end
      private

      def post(path, params)
        url = Plaid.base_url + path
        RestClient.post(url, {
            client_id: Plaid.client_id,
            secret: Plaid.secret,
          }.merge!(params).to_json, content_type: :json) { |rsp, _, _| rsp }
      end

      def parse_response(response)
        parsed = JSON.parse(response)
        case response.code
        when 200
          {
            code: response.code,
            transactions: parsed.fetch("transactions")
          }
        else
          { code: response.code, error: parsed }
        end
      end
    end
  end
end
