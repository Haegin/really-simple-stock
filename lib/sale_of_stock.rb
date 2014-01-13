class SaleOfStock
  attr_reader :stock_item

  def initialize(stock_item)
    unless stock_item.transactions.last.sale?
      raise "The last transaction should be a sale"
    end

    @stock_item = stock_item
    @sale = stock_item.transactions.last
  end

  def sale_price
    @sale.price_per_item
  end

  def number_sold
    @sale.quantity
  end

  def relevant_transactions
    if defined? @relevant_transactions
      @relevant_transactions
    else
      @relevant_transactions = [].tap do |transactions|
        running_total = @stock_item.quantity + @sale.quantity
        prior_transactions = stock_item.transactions[0..-2]
        while running_total > 0
          t = prior_transactions.pop
          if t.purchase?
            running_total -= t.quantity
            transactions.unshift([t.quantity, t.price_per_item])
          else
            running_total += t.quantity
            transactions.unshift([t.quantity, -t.price_per_item])
          end
        end
      end
    end
  end

  def purchase_prices
    if defined? @purchase_prices
      @purchase_prices
    else
      @purchase_prices = [].tap do |unsold|
        relevant_transactions.each do |qty, amount|
          if amount >= 0
            unsold.push([qty, amount])
          else
            while qty > 0
              purchase_qty, purchase_amount = unsold.shift
              if purchase_qty > qty
                unsold.unshift([purchase_qty - qty, purchase_amount])
                qty = 0
              else
                qty -= purchase_qty
              end
            end
          end
        end
      end
    end
  end

  def items_sold
    if defined? @items_sold
      @items_sold
    else
      sale_qty = number_sold
      @items_sold = [].tap do |items_sold|
        while sale_qty > 0
          purchase_qty, purchase_amount = purchase_prices.shift
          if purchase_qty > sale_qty
            # We can get the remaining sale from this purchase
            items_sold << [sale_qty, purchase_amount]
            sale_qty = 0
          else
            # We need to use all of this one and some others
            items_sold << [purchase_qty, purchase_amount]
            sale_qty -= purchase_qty
          end
        end
      end
    end
  end

  def total_profit
    @total_profit ||= items_sold.map do |purchase_qty, purchase_price|
      (sale_price - purchase_price) * purchase_qty
    end.reduce(:+)
  end

  def profit_per_item
    @profit_per_item ||= total_profit / number_sold
  end
end
