class AddIssuerAccount < ActiveRecord::Migration
  def self.up
    @issuer=User.new :email=>ISSUER_EMAIL
    @issuer.save(false)
  end

  def self.down
    @issuer=User.issuer
    @issuer.destroy
  end
end
