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
    
  end
  
  describe "payment to email address" do
    before(:each) do
      @transact=@payer.payments.create :amount=>10,:to=>"bob@email.inv"
    end
    
    it "should be valid" do
      @transact.should be_valid
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
    
  end
  
  
  describe "negative payment" do
    before(:each) do
      @transact=@payer.payments.create :amount=>-10,:payee=>@payee
    end
    
    it "should be invalid" do
      @transact.should_not be_valid
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
  end

  describe "insufficient funds" do
    before(:each) do
      @transact=@payer.payments.create :amount=>1100,:payee=>@payee
    end
        
    it "should be invalid" do
      @transact.should_not be_valid
    end
    
    it "should have error message" do
      @transact.errors.full_messages.should include("Amount over available funds")
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
  end

end
