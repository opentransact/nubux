require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe User do
  describe "issuer" do
    before(:each) do
      @issuer=User.issuer
    end
    
    it "should find issuer" do
      @issuer.should_not be_nil
    end
    
    it "should have 0 balance" do
      @issuer.balance.to_i.should==0
    end
  end
  
end
