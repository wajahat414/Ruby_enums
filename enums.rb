# frozen_string_literal: true

# Your comment
module Enumerable
  #:nodoc:
  def my_each
    i = 0
    while i < to_a.length
      if instance_of?(Hash)
        yield(keys[i], values[i])
      else
        yield(to_a[i])
      end
      i += 1
    end
  end

  def my_each_with_index
    puts self.class
    i = 0
    while i < length
      yield(self[i], i)
      i += 1
    end
  end

  def my_select
    a = []
    i = 0
    my_each do |k|
      if yield(k)
        a[i] = k
        i += 1
      end
    end
    puts a
    a
  end

  def my_any?(pattern = Integer)
    booltest = false
    return false if length.zero?

    if block_given? == false && pattern == Integer

      booltest = true
    else

      my_each do |k|
        booltest = true if k.instance_of?(pattern) || yield(k)
      end

    end

    booltest
  end

  def my_all?(_pattern = Integer)
    my_each do |k|
      return false if [nil, false].include?(k)

      if block_given?
        return false unless yield(k)
      elsif k.instance_of?(Integer) || k.instance_of?(Complex) || k.instance_of?(Float)
        return true
      end
    end
    true
  end
end

print(%w[ant bear cat].my_all? { |word| word.length >= 4 })
# print(%w[ant bear cat].my_all?(/t/) )
print([1, 2i, 3.14].my_all?(Numeric))
print([nil, true, 99].my_all?)
print([].my_all?)
# hash = {}
# %w[cat dog wombat].my_each_with_index do |item, index|
#  hash[item] = index
# end
# puts hash
# a = { cat: 1, bat: 33, fat: 99 }
# a.my_each { |k, v| puts("#{k}:#{v}") }
# a=(1..7)
# a.my_each {|k| puts k}
# a = [1, 2, 3, 4]
# a.my_each { |k| puts k }
