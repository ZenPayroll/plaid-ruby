require 'gusto_plaid/info'
require 'gusto_plaid/balance'
require 'gusto_plaid/config'
require 'gusto_plaid/rest_client'
require 'gusto_plaid/auth'
require 'gusto_plaid/institution'
require 'gusto_plaid/upgrade'
require 'gusto_plaid/connect'
require 'json'

module GustoPlaid
  class << self
    include GustoPlaid::Configure
  end
end
