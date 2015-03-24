module Plaid
  class Auth
    class << self
      def add(type, credentials, options = nil)
        parse_response(post('auth',
          type: type,
          credentials: credentials.to_json,
          options: options.to_json))
      end

      def get(access_token, type = nil)
        parse_response(post('auth/get', access_token: access_token, type: type))
      end

      def step(access_token, mfa, options = nil, type = nil)
        parse_response(post('auth/step',
          access_token: access_token,
          mfa: mfa,
          type: type,
          options: options.to_json))
      end

      private

      def post(path, params)
        Plaid::RestClient.post(path, params)
      end

      def parse_response(response)
        parsed = response.body
        case response.code
        when 200
          {
            code: response.code,
            access_token: parsed['access_token'],
            accounts: parsed['accounts']
          }
        when 201
          {
            code: response.code,
            type: parsed['type'],
            access_token: parsed['access_token'],
            mfa: parsed['mfa']
          }
        else
          { code: response.code, error: parsed }
        end
      end
    end
  end
end
