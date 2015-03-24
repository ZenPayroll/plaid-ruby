require 'plaid/config'
require 'plaid/rest_client'
require 'plaid/auth'
require 'plaid/institution'
require 'plaid/upgrade'
require 'plaid/connect'
require 'json'

module Plaid
  class << self
    include Plaid::Configure
  end
end
