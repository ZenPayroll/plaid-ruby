module GustoPlaid

  class Balance
    class << self
      def balance(access_token)
        parse_response(GustoPlaid::RestClient.post('balance', access_token: access_token))
      end

      private

      def parse_response(response)
        parsed = response.body
        case response.code
        when 200
          {
            code: response.code,
            access_token: parsed['access_token'],
            accounts: parsed['accounts']
          }
        else
          { code: response.code, error: parsed }
        end
      end
    end
  end

end
