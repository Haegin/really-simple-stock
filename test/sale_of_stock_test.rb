require 'test_helper'

describe SaleOfStock do

  describe "With no previous sales" do
    subject do
      purchases = [
        StockTransaction.new(yesterday.prev_day, 10, 100), # 10 @ 10
        StockTransaction.new(yesterday, 10, 50),           # 10 @ 5
      ]
      sale = StockTransaction.new(today, 10, -120)          # 10 @ 12
      stock_item = StockItem.new('Pen', purchases + [sale])
      SaleOfStock.new(stock_item)
    end

    it "has a stock item" do
      subject.stock_item.must_be_instance_of StockItem
    end

    it "knows how much each item sold for" do
      subject.sale_price.must_equal 12
    end

    it "knows how many were sold" do
      subject.number_sold.must_equal 10
    end

    it "knows the items that were sold" do
      sold_items = [[10, 10]]
      subject.items_sold.must_equal sold_items
    end

    it "sells the oldest stock first when there is no prior sale" do
      subject.total_profit.must_equal 20
      subject.profit_per_item.must_equal 2
    end
  end

  describe "with one or more previous sales" do
    subject do
      transactions = [
        StockTransaction.new(today.prev_day(4), 10, 100),
        StockTransaction.new(today.prev_day(3), 5, -75),
        StockTransaction.new(today.prev_day(2), 5, 55),
        StockTransaction.new(today.prev_day(1), 2, -30),
        StockTransaction.new(today, 4, -60)
      ]
      SaleOfStock.new(StockItem.new('Pencils', transactions))
    end

    it "can calculate purchase prices" do
      expected_prices = [[3, 10], [5, 11]]
      subject.purchase_prices.must_equal expected_prices
    end

    it "can calculate total profit" do
      subject.total_profit.must_equal 19
    end

    it "can calculate profit per item" do
      subject.profit_per_item.must_equal 19.0 / 4.0
    end
  end
end
