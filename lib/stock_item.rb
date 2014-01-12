require 'stock_transaction'
require 'sale_of_stock'

class StockItem
  attr_reader :name, :transactions

  def initialize(name, transactions=[])
    @name = name
    @transactions = transactions
  end

  def buy(date, purchase_quantity, price_per_item)
    total_price = price_per_item * quantity
    purchase = StockTransaction.new(date, purchase_quantity, total_price)
    new_transactions = transactions + [purchase]
    StockItem.new(name, new_transactions)
  end

  def sell(date, sale_quantity, price_per_item)
    raise "You can't sell more than you have on hand" if quantity < sale_quantity

    total_price = price_per_item * quantity
    sale = StockTransaction.new(date, sale_quantity, -total_price)
    new_transactions = transactions + [sale]
    new_stock_item = StockItem.new(name, new_transactions)
    SaleOfStock.new(new_stock_item)
  end

  def quantity
    purchased_qty = purchases.map(&:quantity).reduce(:+) || 0
    sold_qty = sales.map(&:quantity).reduce(:+) || 0
    purchased_qty - sold_qty
  end

  private

  def purchases
    transactions.select { |t| t.purchase? }
  end

  def sales
    transactions.select { |t| t.sale? }
  end

end
