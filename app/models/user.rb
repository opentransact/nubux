class User < ActiveRecord::Base
  include Clearance::User
  has_many :client_applications
  has_many :tokens, :class_name=>"OauthToken",:order=>"authorized_at desc",:include=>[:client_application]
  has_many :payments, :class_name=>"Transact",:foreign_key=>"payer_id"
  has_many :receipts, :class_name=>"Transact",:foreign_key=>"payee_id"
  
  has_many :transactions, :class_name=>"Transact",:finder_sql=>'select transacts.* from transacts where (payer_id=#{id} or payee_id=#{id})'
  
  def self.issuer
    find_by_email ISSUER_EMAIL
  end
  
  def balance
    receipts.sum(:amount)-payments.sum(:amount)
  end
  
  def issuer?
    email==ISSUER_EMAIL
  end
  
  def to_s
    email
  end
end
