module Plaid
  class Connect
    class << self
      def get(access_token, options={})
        options.each do |k,v|
          if v.respond_to?(:to_date)
            options[k] = v.to_date.iso8601
          end
        end
        parse_response(Plaid::RestClient.post(
          'connect/get',
          access_token: access_token,
          options: options.to_json))
      end

      private
      def parse_response(response)
        case response.code
        when 200
          {
            code: response.code,
            transactions: response.body.fetch("transactions")
          }
        else
          { code: response.code, error: response.body }
        end
      end
    end
  end
end
