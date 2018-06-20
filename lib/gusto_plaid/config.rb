module GustoPlaid
  module Configure
    attr_accessor :client_id, :secret, :base_url

    KEYS = [:client_id, :secret, :base_url]

    def config
      yield self
      self
    end
  end
end
