module Plaid

  class Info
    class << self
      def get(access_token)
        parse_response(Plaid::RestClient.post('info/get', access_token: access_token))
      end

      private

      def parse_response(response)
        parsed = response.body
        case response.code
        when 200
          {
            code: response.code,
            access_token: parsed['access_token'],
            info: parsed['info']
          }
        else
          { code: response.code, error: parsed }
        end
      end
    end
  end

end
