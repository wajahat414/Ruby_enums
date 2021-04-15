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
end

[1, 2, 3, 4, 5].my_select(&:even?)
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
