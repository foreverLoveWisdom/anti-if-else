# frozen_string_literal: true

# Handle Logic for GildedRose
class GildedRose
  def initialize(items)
    @items = items
  end

  def update_quality
    @items.each do |item|
      if sulfuras?(item)
      elsif generic?(item) && item.quality.positive?
        decrease_quality(item)
        item.sell_in = item.sell_in - 1
      elsif aged_brie?(item)
        increase_quality(item) if quality_less_than_50?(item)
        item.sell_in = item.sell_in - 1
      elsif backstage_pass?(item)
        increase_quality(item) if quality_less_than_50?(item)
        increase_quality(item) if item.sell_in < 11 && quality_less_than_50?(item)
        increase_quality(item) if item.sell_in < 6 && quality_less_than_50?(item)
        item.sell_in = item.sell_in - 1
      end

      if item.sell_in.negative?
        if aged_brie?(item)
          if quality_less_than_50?(item)
            increase_quality(item)
          end
        else
          if backstage_pass?(item)
            item.quality = item.quality - item.quality
          elsif item.quality.positive? && !sulfuras?(item)
            decrease_quality(item)
          end
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

  def quality_less_than_50?(item)
    item.quality < 50
  end

  def decrease_quality(item)
    item.quality = item.quality - 1
  end

  def increase_quality(item)
    item.quality = item.quality + 1
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
