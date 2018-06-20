module GustoPlaid
  class Upgrade
    class << self
      def upgrade(access_token, upgrade_to)
        parse_response(post('upgrade', access_token: access_token, upgrade_to: upgrade_to))
      end
      private

      def post(path, params)
        GustoPlaid::RestClient.post(path, params)
      end

      def parse_response(response)
        case response.code
        when 200
          {
            code: response.code,
            access_token: response.body['access_token'],
          }
        else
          { code: response.code, error: response.body }
        end
      end
    end
  end
end
