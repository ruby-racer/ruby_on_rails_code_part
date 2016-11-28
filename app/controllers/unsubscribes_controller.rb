class UnsubscribesController < ApplicationController
  before_action :authenticate_user!, except: %i(confirm create_from_email)

  def new
  end

  def confirm
    @recipient_email = params[:recipient_email]
    render layout: 'welcome'
  end

  def create
    emails = unsubscribe_find_email_by_order
    if emails.present?
      emails.each do |email|
        unsubscribe_params[:email] = email
        unsubscribe_creation
      end
    elsif unsubscribe_params[:email].present?
      unsubscribe_creation
    else
      @flash = t('.no_order')
    end
    @unsubscribes = current_account ? current_account.unsubscribes : current_user.unsubscribes
  end

  def create_from_email
    order = Order.find_by(buyer_email: params[:recipient_email])
    if order.nil? || order.account.nil?
      redirect_to new_user_session_url && return
    end
    account = order.account
    @unsubscribe = Unsubscribe.where(email: params[:recipient_email],
                                     account: account)
                              .first_or_initialize
    if @unsubscribe.save
      flash[:info] = t('.success')
      redirect_to new_user_session_url
    end
  end

  def destroy
  end

  protected

  def unsubscribe_params
    params.require(:unsubscribe).permit!
  end

  def unsubscribe_find_email_by_order
    if params[:order_id].present?
      orders = Order.where(amazon_order_id: params[:order_id]).where.not(buyer_email: nil)
                    .group(:buyer_email)
      if orders.present?
        emails = []
        orders.each { |order| emails.push(order.buyer_email) }
      end
      emails
    end
  end
end
