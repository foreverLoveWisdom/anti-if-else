# frozen_string_literal: true

# Handle Logic for GildedRose
class GildedRose
  class Generic
    attr_reader :quality, :sell_in

    def initialize(quality, sell_in)
      @quality = quality
      @sell_in = sell_in
    end

    def update
      if @quality.positive?
        @quality -= 1
        @sell_in -= 1
        @quality -= 1 if @sell_in.negative? && @quality.positive?
      end
    end
  end

  class AgedBrie
    attr_reader :quality, :sell_in

    def initialize(quality, sell_in)
      @quality = quality
      @sell_in = sell_in
    end

    def update
      @quality += 1 if @quality < 50
      @sell_in -= 1
      @quality += 1 if @sell_in.negative? && (@quality < 50)
    end
  end

  class BackstagePass
    attr_reader :quality, :sell_in

    def initialize(quality, sell_in)
      @quality = quality
      @sell_in = sell_in
    end

    def update
      @quality = @quality + 1 if @quality < 50
      @quality = @quality + 1 if @sell_in < 11 && @quality < 50
      @quality = @quality + 1 if @sell_in < 6 && @quality < 50
      @sell_in = @sell_in - 1
      @quality = @quality - @quality if @sell_in.negative?
    end
  end

  def initialize(items)
    @items = items
  end

  def update_quality
    @items.each do |item|
      if sulfuras?(item)
      elsif generic?(item)
        generic = Generic.new(item.quality, item.sell_in)
        generic.update
        item.quality = generic.quality
        item.sell_in = generic.sell_in
      elsif aged_brie?(item)
        aged_brie = AgedBrie.new(item.quality, item.sell_in)
        aged_brie.update
        item.quality = aged_brie.quality
        item.sell_in = aged_brie.sell_in
      elsif backstage_pass?(item)
        backstage_pass = BackstagePass.new(item.quality, item.sell_in)
        backstage_pass.update
        item.quality = backstage_pass.quality
        item.sell_in = backstage_pass.sell_in
      end
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
