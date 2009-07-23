class Transact < ActiveRecord::Base
  belongs_to :payer,:class_name=>"User"
  belongs_to :payee,:class_name=>"User"
  
  white_list :method=>:mini
  
  validates_presence_of :amount,:payer,:payee
  
  before_create :set_default_memo
  after_create :perform_callback
  
  default_scope :order =>"created_at desc"
  
  
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
  
  def status
    if new_record?
      'decline'
    else
      'ok'
    end
  end
  
  def insufficient?
    amount>=payer.balance
  end
  
  def to_query_string
    results.collect{|k,v| "#{URI.escape(k.to_s)}=#{URI.escape(v.to_s)}"}.sort.join("&")
  end
  
  # Checks whether a url has a query part already and appends results correctly
  def append_results_to(url)
    uri=URI.parse(url)
    uri.query=(uri.query ? (uri.query||'/')+'&' : '')+to_query_string
    uri.to_s
  end
  
  # results hash for use with callbacks
  def results
    if new_record?
      {
        :status=>'decline',
        :description=>errors.full_messages.join(" ")
      }
    else
      { 
        :to=>payee.email,
        :from=>payer.email,
        :amount=>amount.to_s,
        :txn_date=>created_at.iso8601,
        :memo=>memo,
        :txn_id=>"http://nubux.heroku.com/transacts/#{id}",
        :status=>'ok'
      }
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
    
    if !payer.issuer? && insufficient?
      errors.add( "amount","over available funds")
    end
    
  end
  
  def perform_callback
    if callback_url
      request = Net::HTTP::Post.new(callback_uri.path+(callback_uri.query||''))
      request.set_form_data( results )      
      #request.oauth!(http, client_application.credentials)
      response=http.request(request)
    end
  end
  
  def callback_uri
    @callback_uri||=URI.parse(callback_url) if callback_url
  end
  
  
  def http
    unless @http
      @http=Net::HTTP.new(callback_uri.host, callback_uri.port)
      @http.use_ssl = true if callback_uri.scheme == "https"
    end
    @http
  end
  
end
