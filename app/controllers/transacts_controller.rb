class TransactsController < ApplicationController
  before_filter :login_or_oauth_required
  
  def index
    @transactions=current_user.transactions
  end
  
  def new
    # if there is a to and an amount params we assume it is a simple website payment
    # http://wiki.github.com/opentransact/opentransact/simple-website-payment
    @swp=params[:to]&&params[:amount]
    @transact=Transact.new :to=>params[:to],:amount=>params[:amount],:memo=>params[:memo]
  end
  
  def create
    @transact=current_user.payments.build :to=>params[:to], :amount=>params[:amount], :memo=>params[:memo],:callback_url=>params[:callback_url]
    if @transact.save
      if params[:redirect_url]
        # TODO add error checking if invalid URL
        redirect_to @transact.append_results_to(params[:redirect_url])
      else
        flash[:notice]="You've made a payment of #{@transact.amount} to #{@transact.to}"
        redirect_to transacts_url
      end
    else
      flash[:error]="Your payment could not be made"
      render :action=>:new
    end
  end
  
  def show
    @transact=current_user.transactions.find params[:id]
  end
  
end