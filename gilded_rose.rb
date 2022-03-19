# frozen_string_literal: true

# Handle Logic for GildedRose
class GildedRose
  def initialize(items)
    @items = items
  end

  def update_quality
    @items.each do |item|
      if sulfuras?(item)
      elsif generic?(item)
        if item.quality.positive?
          item.quality = item.quality - 1
          item.sell_in = item.sell_in - 1
          if item.sell_in.negative?
            if item.quality.positive?
              item.quality = item.quality - 1
            end
          end
        end
      elsif aged_brie?(item)
        item.quality = item.quality + 1 if item.quality < 50
        item.sell_in = item.sell_in - 1
        if item.sell_in.negative?
          if item.quality < 50
            item.quality = item.quality + 1
          end
        end
      elsif backstage_pass?(item)
        item.quality = item.quality + 1 if item.quality < 50
        item.quality = item.quality + 1 if item.sell_in < 11 && item.quality < 50
        item.quality = item.quality + 1 if item.sell_in < 6 && item.quality < 50
        item.sell_in = item.sell_in - 1
        if item.sell_in.negative?
          item.quality = item.quality - item.quality
        end
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
