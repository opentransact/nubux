require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Transact do
  before(:each) do
    @payer=users(:quentin)
    @payee=users(:bob)
    Transact.issue_to @payer, 1000
  end
  
  it "payer should have 1000" do
    @payer.balance.to_i.should==1000
  end
  
  it "payee should have 1000" do
    @payee.balance.to_i.should==0
  end
  
  it "payer should have 1 receipt" do
    @payer.should have(1).receipts
  end
  
  it "payer should have 0 payments" do
    @payer.should have(0).payments
  end
  
  it "payee should have 0 receipts" do
    @payee.should have(0).receipts
  end
  
  it "payee should have 0 payments" do
    @payee.should have(0).payments
  end
  
  it "should have 1000 in circulation" do
    Transact.circulation.to_i.should==1000
  end
  
  describe "payment" do
    before(:each) do
      @transact=@payer.payments.create :amount=>10,:payee=>@payee
    end
    
    it "should be valid" do
      @transact.should be_valid
    end
    
    it "should have status of ok" do
      @transact.status.should=='ok'
    end
    
    it "should have to field set to payees email address" do
      @transact.to.should==@payee.email
    end
  
    it "payer should have 1000" do
      @payer.balance.to_i.should==990
    end
  
    it "payee should have 1000" do
      @payee.balance.to_i.should==10
    end
    
    it "payer should have 1 receipt" do
      @payer.should have(1).receipts
    end

    it "payer should have 1 payment" do
      @payer.should have(1).payments
    end

    it "payee should have 1 receipt" do
      @payee.should have(1).receipts
    end

    it "payee should have 0 payments" do
      @payee.should have(0).payments
    end
  
    it "should have 1000 in circulation" do
      Transact.circulation.to_i.should==1000
    end
    
    it "should have default memo" do
      @transact.memo.should=="payment to #{@payee.email}"
    end
    
    it "should have result hash" do
      @transact.results.should=={
        :to=>@transact.payee.email,
        :from=>@transact.payer.email,
        :amount=>@transact.amount.to_s,
        :txn_date=>@transact.created_at.iso8601,
        :memo=>@transact.memo,
        :txn_id=>"http://nubux.heroku.com/transacts/#{@transact.id}",
        :status=>'ok'
      }
    end
    
  end
  
  describe "payment to email address" do
    before(:each) do
      @transact=@payer.payments.create :amount=>10,:to=>"bob@email.inv"
    end
    
    it "should be valid" do
      @transact.should be_valid
    end
    
    it "should have status of ok" do
      @transact.status.should=='ok'
    end
    
    it "should set correct payee" do
      @transact.payee.should==@payee
    end
  
    it "payer should have 1000" do
      @payer.balance.to_i.should==990
    end
  
    it "payee should have 1000" do
      @payee.balance.to_i.should==10
    end
    
    it "payer should have 1 receipt" do
      @payer.should have(1).receipts
    end

    it "payer should have 1 payment" do
      @payer.should have(1).payments
    end

    it "payee should have 1 receipt" do
      @payee.should have(1).receipts
    end

    it "payee should have 0 payments" do
      @payee.should have(0).payments
    end
  
    it "should have 1000 in circulation" do
      Transact.circulation.to_i.should==1000
    end
    
    it "should have result hash" do
      @transact.results.should=={
        :to=>@transact.payee.email,
        :from=>@transact.payer.email,
        :amount=>@transact.amount.to_s,
        :txn_date=>@transact.created_at.iso8601,
        :memo=>@transact.memo,
        :txn_id=>"http://nubux.heroku.com/transacts/#{@transact.id}",
        :status=>'ok'
      }
    end
    
  end
  
  
  describe "negative payment" do
    before(:each) do
      @transact=@payer.payments.create :amount=>-10,:payee=>@payee
    end
    
    it "should be invalid" do
      @transact.should_not be_valid
    end
    
    it "should have status of declined" do
      @transact.status.should=='decline'
    end
    
    it "should have error message" do
      @transact.errors.full_messages.should include("Amount should be a positive value")
    end
  
    it "payer should have 1000" do
      @payer.balance.to_i.should==1000
    end
  
    it "payee should have 1000" do
      @payee.balance.to_i.should==0
    end
  
    it "payer should have 1 receipt" do
      @payer.should have(1).receipts
    end
  
    it "payer should have 0 payments" do
      @payer.should have(0).payments(true)
    end
  
    it "payee should have 0 receipts" do
      @payee.should have(0).receipts
    end
  
    it "payee should have 0 payments" do
      @payee.should have(0).payments
    end
  
    it "should have 1000 in circulation" do
      Transact.circulation.to_i.should==1000
    end
    
    
    it "should have result hash" do
      @transact.results.should=={
        :status=>'decline',
        :description=>"Amount should be a positive value"
      }
    end
    
  end

  describe "insufficient funds" do
    before(:each) do
      @transact=@payer.payments.create :amount=>1100,:payee=>@payee
    end
        
    it "should be invalid" do
      @transact.should_not be_valid
    end
    
    it "should have status of declined" do
      @transact.status.should=='decline'
    end
    
    it "should have error message" do
      @transact.errors.full_messages.should include("Amount over available funds")
    end
    
    it "should have insufficient funds" do
      @transact.should be_insufficient
    end
  
    it "payer should have 1000" do
      @payer.balance.to_i.should==1000
    end
  
    it "payee should have 1000" do
      @payee.balance.to_i.should==0
    end
  
    it "payer should have 1 receipt" do
      @payer.should have(1).receipts
    end
  
    it "payer should have 0 payments" do
      @payer.should have(0).payments(true)
    end
  
    it "payee should have 0 receipts" do
      @payee.should have(0).receipts
    end
  
    it "payee should have 0 payments" do
      @payee.should have(0).payments
    end
  
    it "should have 1000 in circulation" do
      Transact.circulation.to_i.should==1000
    end

    it "should have result hash" do
      @transact.results.should=={
        :status=>'decline',
        :description=>"Amount over available funds"
      }
    end
  end

  describe "adding payment confirmation to url" do
    before(:each) do
      @transact=@payer.payments.create :amount=>10,:payee=>@payee,:memo=>"1 beer"
    end
    
    it "should have correct query string" do
      @transact.to_query_string.should=="amount=#{@transact.amount}&from=#{URI.escape(@transact.payer.email)}&memo=1%20beer&status=ok&to=#{URI.escape(@transact.payee.email)}&txn_date=#{@transact.created_at.iso8601}&txn_id=http://nubux.heroku.com/transacts/#{@transact.id}"      
    end
    
    it "should append query string to url without existing query" do
      @transact.append_results_to("http://someone.inv/order/1").should=="http://someone.inv/order/1?#{@transact.to_query_string}"
    end

    it "should append query string to url with existing query" do
      @transact.append_results_to("http://someone.inv/order/1?cart_id=433").should=="http://someone.inv/order/1?cart_id=433&#{@transact.to_query_string}"
    end

    it "should append query string to url with existing query and anchor" do
      @transact.append_results_to("http://someone.inv/order/1?cart_id=433#wrench").should=="http://someone.inv/order/1?cart_id=433&#{@transact.to_query_string}#wrench"
    end
  end


  describe "perform callback" do
    before(:each) do
      @transact=@payer.payments.build :amount=>10,:payee=>@payee,:memo=>"1 beer",:callback_url=>"http://test.inv/order/1/payment"
      # mocking http is a pain
      @response=mock("response")
      @response.stub!(:body).and_return("RESPONSE")
      @response.stub!(:code).and_return('200')
      @http=@transact.send :http
      @http.stub!(:do_start)
      @http.stub!(:do_finish)
      @http.should_receive(:request).and_return(@response)
      
    end
    
    it "should call callback" do
      @transact.save      
    end
  end

end
