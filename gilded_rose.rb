# frozen_string_literal: true

class GildedRose
  def initialize(items)
    @items = items
  end

  def update_quality
    @items.each do |item|
      if (item.name != 'Aged Brie') && (item.name != 'Backstage passes to a TAFKAL80ETC concert')
        decrease_quality(item) if item.quality.positive? && (item.name != 'Sulfuras, Hand of Ragnaros')
      elsif quality_less_than_50?(item)
        increase_quality(item)
        if item.name == 'Backstage passes to a TAFKAL80ETC concert'
          increase_quality(item) if item.sell_in < 11 && quality_less_than_50?(item)
          increase_quality(item) if item.sell_in < 6 && quality_less_than_50?(item)
        end
      end
      item.sell_in = item.sell_in - 1 if item.name != 'Sulfuras, Hand of Ragnaros'
      if item.sell_in.negative?
        if item.name != 'Aged Brie'
          if item.name != 'Backstage passes to a TAFKAL80ETC concert'
            decrease_quality(item) if item.quality.positive? && (item.name != 'Sulfuras, Hand of Ragnaros')
          else
            item.quality = item.quality - item.quality
          end
        elsif quality_less_than_50?(item)
          increase_quality(item)
        end
      end
    end
  end

  private

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
