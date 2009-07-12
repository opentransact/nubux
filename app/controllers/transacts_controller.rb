class TransactsController < ApplicationController
  before_filter :login_or_oauth_required
  
  def index
    @transactions=current_user.transactions
  end
  
  def new
    @transact=Transact.new :to=>params[:to],:amount=>params[:amount],:memo=>params[:memo]
  end
  
  def create
    @transact=current_user.payments.create :to=>params[:to],:amount=>params[:amount],:memo=>params[:memo]
    redirect_to transacts_url
  end
  
  def show
    @transact=current_user.transactions.find params[:id]
  end
  
end