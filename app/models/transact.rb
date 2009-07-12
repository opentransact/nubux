class Transact < ActiveRecord::Base
  belongs_to :payer,:class_name=>"User"
  belongs_to :payee,:class_name=>"User"
  
  validates_presence_of :amount,:payer,:payee
  
  before_create :set_default_memo
  
  # Issues funds to a payee
  def self.issue_to(payee,amount)
    User.issuer.payments.create :amount=>amount,:payee=>payee
  end
  
  # The amount of funds issued to users in the system
  def self.circulation
    -(User.issuer.balance)
  end
  
  # Convenience method to set the payee using an email address
  def to=(email)
    return if email.blank?
    self.payee=User.find_by_email(email)
  end
  
  # Convenience method to get the payees email address
  def to
    payee.email if payee
  end
  
  def counterparty_for(user)
    if payee==user
      return payer
    elsif payer==user
      return payee
    end
  end
  
  protected
  
  def set_default_memo
    self.memo||="payment to #{@payee.email}"
  end
  
  def validate
    unless amount>0
      errors.add("amount","should be a positive value")
    end
    
    unless payer.issuer? || amount<=payer.balance
      errors.add( "amount","over available funds")
    end
    
  end
end
