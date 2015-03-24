require 'net/http'
require 'json'
require 'uri'
module Plaid
  class RestClient
    class JSONResponse
      attr_reader :code, :body

      def initialize(res)
        @code = res.code.to_i
        @body = JSON.parse(res.body)
      end
    end

    class << self
      def post(path, options={})
        uri = build_uri(path)
        res = Net::HTTP.post_form(uri, options.merge!(client_id: Plaid.client_id, secret: Plaid.secret))
        return JSONResponse.new(res)
      end

      def get(path, id=nil)
        uri = build_uri(path, id)
        res = Net::HTTP.get_response(uri)
        JSONResponse.new(res)
      end

      protected
      def build_uri(path, option=nil)
        path = path + '/' + option unless option.nil?
        URI.parse(Plaid.base_url + path)
      end
    end
  end
end

