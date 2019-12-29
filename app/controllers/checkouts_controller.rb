class CheckoutsController < ApplicationController
  require 'rubygems'
  require 'braintree'

  def transaction(gateway, amount, customer_id, sfs_bool)
    gateway.transaction.sale(
      amount: amount,
      customer_id: customer_id,
      options: {
        submit_for_settlement: sfs_bool
      }
    )
  end

  def vault(gateway, nonce, first_name, email)
    gateway.customer.create(
      payment_method_nonce: nonce,
      first_name: first_name,
      email: email
    )
  end

  def create
    gateway = Braintree::Gateway.new(
      environment: :sandbox,
      merchant_id: 'hqk9y3rc8z3crhwg',
      public_key: '9sgptsv5sgw9kkjd',
      private_key: '31699066076e5a360797d6b8b8f5c28b'
    )
    cardtype = params[:card_type]
    if cardtype == "Visa"
      customer_result = vault(gateway, params[:payment_method_nonce], params[:first_name], params[:email])
      customer_id = customer_result.customer.id
      transaction_result = transaction(gateway, '1000.00', customer_id, true)
      @message = transaction_result.success?
    else
      @message = "Irrelevant, Not a Visa"
    end
  end

end
