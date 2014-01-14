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

  def purchase_prices
    if defined? @purchase_prices
      @purchase_prices
    else
      @purchase_prices = [].tap do |unsold|
        # Under FIFO, the last item I sell is the most recent one I purchased,
        # thus if I have 20 items on hand they're the last 20 I bought.
        stock_on_hand = @stock_item.quantity + @sale.quantity
        purchases = @stock_item.transactions.select {|t| t.purchase? }
        while stock_on_hand > 0
          purchase = purchases.pop
          qty_in_this_purchase = [purchase.quantity, stock_on_hand].min
          unsold.unshift([qty_in_this_purchase, purchase.price_per_item])
          stock_on_hand -= qty_in_this_purchase
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
