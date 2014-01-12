require 'test_helper'
require 'stock_item'

describe StockItem do
  it "can be created with the name of the item" do
    StockItem.new('Pen').must_be_instance_of StockItem
  end

  it "knows it's own name" do
    StockItem.new('Pen').name.must_equal 'Pen'
  end
end
