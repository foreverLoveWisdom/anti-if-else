require 'pry-byebug'
# frozen_string_literal: true

module Inventory
  class Quality
    attr_reader :amount

    def initialize(amount)
      @amount = amount
    end

    def degrade
      @amount -= 1 if amount.positive?
    end

    def increase
      @amount += 1 if amount < 50
    end

    def reset
      @amount = 0
    end
  end

  class Generic
    attr_reader :sell_in

    def initialize(quality, sell_in)
      @quality = Quality.new(quality)
      @sell_in = sell_in
    end

    def update
      @quality.degrade
      @sell_in -= 1
      @quality.degrade if @sell_in.negative?
    end

    def quality
      @quality.amount
    end
  end

  class AgedBrie
    attr_reader :sell_in

    def initialize(quality, sell_in)
      @quality = Quality.new(quality)
      @sell_in = sell_in
    end

    def update
      @quality.increase
      @sell_in -= 1
      @quality.increase if @sell_in.negative?
    end

    def quality
      @quality.amount
    end
  end

  class BackstagePass
    attr_reader :sell_in

    def initialize(quality, sell_in)
      @quality = Quality.new(quality)
      @sell_in = sell_in
    end

    def update
      @quality.increase
      @quality.increase if @sell_in < 11
      @quality.increase if @sell_in < 6
      @sell_in -= 1
      @quality.reset if @sell_in.negative?
    end

    def quality
      @quality.amount
    end
  end

  class Sulfuras
    attr_reader :sell_in

    def initialize(quality, sell_in)
      @quality = Quality.new(quality)
      @sell_in = sell_in
    end

    def update; end

    def quality
      @quality.amount
    end
  end
end

# Handle Logic for GildedRose
class GildedRose
  class GoodCategory
    def build_for(item)
      if sulfuras?(item)
        Inventory::Sulfuras.new(item.quality, item.sell_in)
      elsif generic?(item)
        Inventory::Generic.new(item.quality, item.sell_in)
      elsif aged_brie?(item)
        Inventory::AgedBrie.new(item.quality, item.sell_in)
      elsif backstage_pass?(item)
        Inventory::BackstagePass.new(item.quality, item.sell_in)
      end
    end

    private

    def generic?(item)
      !(sulfuras?(item) || backstage_pass?(item) || aged_brie?(item))
    end

    def sulfuras?(item)
      item.name == 'Sulfuras, Hand of Ragnaros'
    end

    def backstage_pass?(item)
      item.name == 'Backstage passes to a TAFKAL80ETC concert'
    end

    def aged_brie?(item)
      item.name == 'Aged Brie'
    end
  end

  def initialize(items)
    @items = items
  end

  def update_quality
    @items.each do |item|
      good = GoodCategory.new.build_for(item)
      good.update
      item.quality = good.quality
      item.sell_in = good.sell_in
    end
  end
end

class Item
  attr_accessor :name, :sell_in, :quality

  def initialize(name, sell_in, quality)
    @name = name
    @sell_in = sell_in
    @quality = quality
  end

  def to_s
    "#{@name}, #{@sell_in}, #{@quality}"
  end
end
