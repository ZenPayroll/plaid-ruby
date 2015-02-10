module Plaid
  class Auth
    class << self
      SSL_VERSION = 'TLSv1'
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
        request = RestClient::Request.new(
          url: url,
          method: :post,
          payload: {
            client_id: Plaid.client_id,
            secret: Plaid.secret
          }.merge!(params).to_json,
          headers: {content_type: :json},
          ssl_version: SSL_VERSION)
        request.execute { |rsp, _, _| rsp }
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
