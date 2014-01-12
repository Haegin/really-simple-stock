class SaleOfStock
  attr_reader :stock_item

  def initialize(stock_item)
    unless stock_item.transactions.last.sale?
      raise "The last transaction should be a sale"
    end

    @stock_item = stock_item
    @sale = stock_item.transactions.last
  end

  def relevant_transactions
    running_total = @stock_item.quantity + @sale.quantity
    transactions = []
    # Work through transactions backwards, excluding the sale we just made
    stock_item.transactions[0..-2].reverse.each do |t|
      if t.purchase?
        running_total -= t.quantity
        transactions.unshift([t.quantity, t.price_per_item])
      else
        running_total += t.quantity
        transactions.unshift([t.quantity, -t.price_per_item])
      end

      # If the stock on hand ever reaches zero we can stop as we've sold all
      # stock until this point.
      if running_total <= 0
        break
      end
    end
    transactions
  end

  def unsold_stock_with_prices
    [].tap do |unsold|
      relevant_transactions.each do |qty, amount|
        if amount > 0
          unsold.push([qty, amount])
        else
          while qty > 0
            purchase_qty, purchase_amount = unsold.shift
            if purchase_qty > qty
              unsold.unshift([purchase_qty - qty, purchase_amount])
              sale_qty = 0
            else
              sale_qty -= purchase_qty
            end
          end
        end
      end
    end
  end

  def total_profit
    sale_qty = @sale.quantity
    profit = 0
    while sale_qty > 0
      qty, amount = unsold_stock_with_prices.shift
      if amount > sale_qty
        profit += sale_qty * (@sale.amount - amount)
        sale_qty = 0
      else
        profit += qty * (@sale.amount - amount)
        sale_qty -= qty
      end
    end
    profit
  end
end
