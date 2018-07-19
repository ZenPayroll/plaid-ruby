require 'net/http'
require 'json'
require 'uri'
require 'cgi'
module GustoPlaid
  class RestClient
    class JSONResponse
      attr_reader :code, :body

      def initialize(res)
        @code = res.code.to_i
        @body = JSON.parse(res.body)
      end
    end

    class << self
      def post_with_retry(retry_count, path, options={})
        begin
          return post(path, options)
        rescue Net::ReadTimeout, Net::HTTPBadResponse => e
          retry_count -= 1
          if retry_count > 0
            retry
          else
            raise e
          end
        end
      end

      def post(path, options={})
        uri = build_uri(path)
        res = Net::HTTP.post_form(uri, options.merge!(client_id: GustoPlaid.client_id, secret: GustoPlaid.secret))
        return JSONResponse.new(res)
      end

      def get(path, id=nil)
        uri = build_uri(path, id)
        res = Net::HTTP.get_response(uri)
        JSONResponse.new(res)
      end

      def delete(path, options={})
        uri = URI.parse(GustoPlaid.base_url)
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = (uri.scheme == 'https')

        delete_request = Net::HTTP::Delete.new('/' + path)
        delete_request.body = build_form_params(options.merge!(client_id: GustoPlaid.client_id, secret: GustoPlaid.secret))

        response = http.request(delete_request)
        JSONResponse.new(response)
      end

      protected
      def build_uri(path, option=nil)
        path = path + '/' + option unless option.nil?
        URI.parse(GustoPlaid.base_url + path)
      end

      def build_form_params(params={})
        params.collect { |k, v| "#{k.to_s}=#{CGI::escape(v.to_s)}" }.join('&')
      end
    end
  end
end
