module Plaid
  class Upgrade
    class << self
      def upgrade(access_token, upgrade_to)
        parse_response(post('upgrade', access_token: access_token, upgrade_to: upgrade_to))
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
            access_token: parsed['access_token'],
          }
        else
          { code: response.code, error: parsed }
        end
      end
    end
  end
end
