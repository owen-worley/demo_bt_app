class CheckoutsController < ApplicationController
  require 'rubygems'
  require 'braintree'

  def index
    @checkouts = Checkout.all
  end

  def show
    @checkout = Checkout.find(params[:id])
  end

  def transaction(gateway, amount, customer_id, postal_code, sfs_bool)
    gateway.transaction.sale(
      amount: amount,
      customer_id: customer_id,
      options: {
        submit_for_settlement: sfs_bool
      },
      billing: {
        postal_code: postal_code
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
      transaction_result = transaction(gateway, '1000.00', customer_id, params[:postal_code], true)
      @message = transaction_result.success?
#      @checkout = Checkout.new(params[:email], params[:first_name], customer_id, params[:postal_code], '1000.00', params[:card_type])
      @checkout = Checkout.new(params[:checkout])
      @checkout.save
    else
      @message = "Irrelevant, Not a Visa"
    end
  end

end
