# frozen_string_literal: true

# module enumerable
module Enumerable
  #:nodoc:
  def my_each(index = 0)
    return to_enum unless block_given?

    while index < to_a.length
      if instance_of?(Hash)
        yield(keys[index], values[index])
      else
        yield(to_a[index])
      end
      index += 1
    end
    self
  end

  def my_each_with_index(index = 0)
    return to_enum unless block_given?

    while index < to_a.length
      yield(to_a[index], index)
      index += 1
    end
    self
  end

  def my_select(arr = [], index = 0)
    return to_enum unless block_given?

    my_each do |k|
      if yield(k)
        arr[i] = k
        index += 1
      end
    end
    arr
  end

  def my_any?(pattern = Integer, bar: false)
    return false if length.zero?

    if block_given? == false && pattern == Integer

      bar = true
    else

      my_each do |k|
        bar = true if k.instance_of?(pattern) || yield(k)
      end

    end

    bar
  end

  def check?(value, pattern, flag = nil)
    if flag
      return true if value.instance_of?(pattern)
      return true if value.instance_of?(Complex) || value.instance_of?(Float) || value.instance_of?(Integer)
    elsif value.to_s.match(pattern.to_s)
      return true
    end

    false
  end

  def my_all?(pattern: false, flag: false)
    my_each do |k|
      return false unless k

      if block_given?
        return false unless yield(k)
      elsif (flag = [Integer, Float, String, Numeric].include?(pattern)) || pattern.to_s.include?('?')
        return false unless check?(flag, pattern, x)

      end
    end
    true
  end

  def my_none?(pattern = Integer)
    my_each do |k|
      return false if k == true

      if block_given?
        return false if yield(k)
      elsif k.instance_of?(pattern)
        return false
      end
    end
    true
  end

  def my_count(comp = nil, count = 0)
    my_each do |k|
      count += 1 if block_given? && yield(k)
      count += 1 if comp && k == comp
    end

    return length if !block_given? && comp.nil?

    count
  end

  def my_inject(mem = 0)
    my_each do |k|
      mem = mem.to_s if k.instance_of?(String)
      mem = yield(mem, k)
    end
    mem
  end

  def my_map(my_proc = nil, index = 0)
    arr = to_a
    my_each do |i|
      if my_proc
        arr[index] = my_proc.call(i)
      elsif block_given?
        arr[index] = yield(i)
      end

      index += 1
    end
    arr
  end
end

def multiply_els(arr)
  arr.my_inject(1) { |product, n| product * n }
end

x = %w[ant bear cat].all? { |word| word.length >= 3 } #=> true
y = %w[ant bear cat].all? { |word| word.length >= 4 } #=> false
z = %w[ant bear cat].all?(/t/)                        #=> false
a = [1, 2i, 3.14].all?(Numeric)                       #=> true
b = [nil, true, 99].all?                              #=> false
c = [].all?
print x, y, z, a, b, c

# a = { cat: 1, bat: 33, fat: 99 }
# enum=a.my_each {|k,v| puts "#{k}:#{v}"}

# hash = {}
# 2a.each_with_index do |item, index|
#  hash[item] = index
# end
# puts hash

# print enum
# a = (1..7)
# range = a.each
# print range
# a = [1, 2, 3, 4]
# array=a.my_each { |k| puts k }
# print array

# print(multiply_els([2, 4, 5]))

# longest = %w[cat sheep bear].my_inject do |memo, word|
# memo.length > word.length ? memo : word
# end
# print(longest)
# print((5..10).my_inject(1) { |product, n| product * n} )
# my_proc = proc { |i| i * i }
# print((1..4).my_map(my_proc))
# print((1..4).my_map { |i| i * i })

# ary = [1, 2, 4, 2]
# print(ary.my_count)               #=> 4
# print(ary.my_count(2))            #=> 2
# print(ary.my_count(&:even?))

# print(%w[ant bear cat].my_none? { |word| word.length >= 5 })
# print([1, 42].my_none?(Float))
# print([nil].my_none?)
