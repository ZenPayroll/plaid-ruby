module Plaid
  class Info
    def initialize
      Plaid::Configure::KEYS.each do |key|
        instance_variable_set(:"@#{key}", Plaid.instance_variable_get(:"@#{key}"))
      end
    end

    def add(type, credentials)
      parse_response(post('/info', type: type, credentials: credentials))
    end

    def get(access_token)
      parse_response(post('/info/get', access_token: access_token))
    end

    private

    def post(path, params)
      url = Plaid.base_url +path
      RestClient.post(url, {
        client_id: Plaid.client_id,
        secret: Plaid.secret
      }.merge!(params).to_json, content_type: :json)
    end

    def parse_response(response)
      parsed = JSON.parse(response)
      case response.code
      when 200
        {
          code: response.code,
          access_token: parsed['access_token'],
          accounts: parsed['accounts'],
          info: parsed['info']
        }
      when 201
        {
          code: response.code,
          type: parsed['type'],
          access_token: parsed['access_token'],
          mfa_info: parsed['mfa_info'],
          info: parsed['info']
        }
      else
        { code: response.code, message: parsed }
      end
    end
  end
end
