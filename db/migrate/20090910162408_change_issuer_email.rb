class ChangeIssuerEmail < ActiveRecord::Migration
  def self.up
    execute 'update users set email="nubux@stakeventures.com" where email="issuer@nubux.heroku.com"'
  end

  def self.down
    execute 'update users set email="issuer@nubux.heroku.com" where email="nubux@stakeventures.com"'
  end
end
