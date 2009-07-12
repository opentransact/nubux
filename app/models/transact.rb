class Transact < ActiveRecord::Base
  belongs_to :payer,:class_name=>"User"
  belongs_to :payee,:class_name=>"User"
  
  validates_presence_of :amount,:payer,:payee
  
  def self.issue_to(payee,amount)
    User.issuer.payments.create :amount=>amount,:payee=>payee
  end
  
  def self.circulation
    -(User.issuer.balance)
  end
  
  def to=(email)
    self.payee=User.find_by_email(email)
  end
  
  def to
    payee.email if payee
  end
  
  protected
  
  def validate
    unless amount>0
      errors.add("amount","should be a positive value")
    end
    
    unless payer.issuer? || amount<=payer.balance
      errors.add( "amount","over available funds")
    end
    
  end
end
