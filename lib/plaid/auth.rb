module Plaid
  class Auth
    class << self
      def add(type, credentials, options = nil)
        parse_response(post('auth',
          type: type,
          credentials: credentials,
          options: options))
      end

      def get(access_token, type = nil)
        parse_response(post('auth/get', access_token: access_token, type: type))
      end

      def step(access_token, mfa, options = nil, type = nil)
        parse_response(post('auth/step',
          access_token: access_token,
          mfa: mfa,
          type: type,
          options: options))
      end

      private

      def post(path, params)
        url = Plaid.base_url + path
        RestClient.post(url, {
          client_id: Plaid.client_id,
          secret: Plaid.secret
        }.merge!(params).to_json, content_type: :json) { |rsp, _, _| rsp }
      end

      def parse_response(response)
        parsed = JSON.parse(response)
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
