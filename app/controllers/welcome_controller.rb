class WelcomeController < ApplicationController
  require 'rubygems'
  require 'braintree'

  def index
    gateway = Braintree::Gateway.new(
      environment: :sandbox,
      merchant_id: 'hqk9y3rc8z3crhwg',
      public_key: '9sgptsv5sgw9kkjd',
      private_key: '31699066076e5a360797d6b8b8f5c28b'
    )
    @client_token = gateway.client_token.generate()
  end

end
