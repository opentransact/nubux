atom_feed do |feed|
  feed.title("Transactions for #{current_user.email}")
  feed.updated(@transactions.first.created_at)

  for transaction in @transactions
    feed.entry(transaction) do |entry|
      if transaction.payer==current_user
        entry.title("Payment of #{number_as_currency(transaction.amount)} made to #{transaction.payee.email}")
      else
        entry.title("Payment of #{number_as_currency(transaction.amount)} received from #{transaction.payee.email}")
      end
      entry.content(transaction.memo,:type=>"text")
      
      entry.author do |author|
        author.name(transaction.user)
      end
    end
  end
end