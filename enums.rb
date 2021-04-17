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

  def my_count(comp = nil)
    count = 0
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

# print(multiply_els([2, 4, 5]))

# longest = %w[cat sheep bear].my_inject do |memo, word|
# memo.length > word.length ? memo : word
# end
# print(longest)
# print((5..10).my_inject(1) { |product, n| product * n} )
my_proc = proc { |i| i * i }
print((1..4).my_map(my_proc))
print((1..4).my_map { |i| i * i })

# ary = [1, 2, 4, 2]
# print(ary.my_count)               #=> 4
# print(ary.my_count(2))            #=> 2
# print(ary.my_count(&:even?))

# print(%w[ant bear cat].my_none? { |word| word.length >= 5 })
# print([1, 42].my_none?(Float))
# print([nil].my_none?)
# print(%w[ant bear cat].my_all?(/t/) )
# print([1, 2i, 3.14].my_all?(Numeric))
# print([nil, true, 99].my_all?)
# print([].my_all?)
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
