class User < ActiveRecord::Base
  include Clearance::User
  has_many :client_applications
  has_many :tokens, :class_name=>"OauthToken",:order=>"authorized_at desc",:include=>[:client_application]
  has_many :payments, :class_name=>"Transact",:foreign_key=>"payer_id"
  has_many :receipts, :class_name=>"Transact",:foreign_key=>"payee_id"
  
  has_many :transactions, :class_name=>"Transact",:finder_sql=>'select transacts.* from transacts where (payer_id=#{id} or payee_id=#{id}) order by created_at desc'
  
  after_create :fund_account
  
  # The issuer is the account that issues money into the system. It is the only
  # account allowed to have a negative balance. Set the email address of issuer in environment.rb
  def self.issuer
    find_by_email ISSUER_EMAIL
  end
  
  # Naive implementation of balance
  def balance
    receipts.sum(:amount)-payments.sum(:amount)
  end
  
  # Is this user the issuer?
  def issuer?
    email==ISSUER_EMAIL
  end
  
  def to_s
    email
  end
  
  protected
  
  # Fund all new accounts with 1000
  def fund_account
    Transact.issue_to self,1000
  end
end
