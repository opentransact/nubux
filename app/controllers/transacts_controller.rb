class TransactsController < ApplicationController
  before_filter :login_or_oauth_required
  
  def index
    @transactions=current_user.transactions
  end
  
  def new
    @transact=Transact.new params[:transact]
  end
  
  def create
    @transact=current_user.payments.create params[:transact]
  end
  
  def show
    @transact=current_user.transactions.find params[:id]
  end
  
end