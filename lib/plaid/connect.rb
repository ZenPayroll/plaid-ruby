require 'date'

module Plaid
  class Connect
    class << self
      def base(username, password, type, options={})
        dates_to_iso8601!(options)

        parse_response(Plaid::RestClient.post(
            'connect',
            username: username,
            password: password,
            type: type,
            options: options.to_json
          ))
      end

      def get(access_token, options={})
        dates_to_iso8601!(options)

        parse_response(Plaid::RestClient.post(
            'connect/get',
            access_token: access_token,
            options: options.to_json))
      end

      def step(access_token, mfa, options = nil, type = nil)
        parse_response(Plaid::RestClient.post(
          'connect/step',
          access_token: access_token,
          mfa: mfa,
          type: type,
          options: options.to_json))
      end

      private

      def dates_to_iso8601!(hash)
        classes = [Date, DateTime, Time]
        hash.each do |k, v|
          if classes.include?(v.class)
            hash[k] = v.to_date.iso8601
          end
        end
      end

      def parse_response(response)
        parsed = response.body
        case response.code
        when 200
          {
            code: response.code,
            access_token: parsed['access_token'],
            accounts: parsed['accounts'],
            transactions: parsed['transactions']
          }
        when 201
          {
            code: response.code,
            type: parsed['type'],
            access_token: parsed['access_token'],
            mfa: parsed.fetch['mfa']
          }
        else
          {code: response.code, error: response.body}
        end
      end
    end
  end
end
