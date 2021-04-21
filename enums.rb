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

  def check?(value, pattern, flag = nil)
    if flag
      return true if value.instance_of?(pattern)
      return true if value.instance_of?(Complex) || value.instance_of?(Float) || value.instance_of?(Integer)
    elsif value.to_s.match(pattern.to_s)
      return true
    end

    false
  end

  def my_all?(pattern = nil, flag: false)
    my_each do |k|
      return false unless k

      if block_given?
        return false unless yield(k)
      elsif (flag = [Integer, Float, String, Numeric].include?(pattern)) || pattern.to_s.include?('?')
        return false unless check?(k, pattern, flag)
      end
    end
    true
  end

  def my_any?(pattern = nil, flag: false)
    my_each do |k|
      if block_given?
        return true if yield(k)
      elsif (flag = [Integer, Float, String, Numeric].include?(pattern)) || pattern.to_s.include?('?')
        return true if check?(k, pattern, flag)
      elsif k
        return true
      end
    end
    false
  end

  def my_none?(pattern = nil, flag: false)
    my_each do |k|
      if block_given?
        return false if yield(k)
      elsif (flag = [Integer, Float, String, Numeric].include?(pattern)) || pattern.to_s.include?('?')
        return false if check?(k, pattern, flag)
      elsif k
        return false
      end
    end
    true
  end

  def my_count(comp = nil, count = 0)
    my_each do |k|
      count += 1 if block_given? && yield(k) || comp && k == comp
    end

    return to_a.length if !block_given? && comp.nil?

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
    my_each do |i|
      if my_proc
        to_a[index] = my_proc.call(i)
      elsif block_given?
        to_a[index] = yield(i)
      end

      index += 1
    end
    to_a
  end
end

def multiply_els(arr)
  arr.my_inject(1) { |product, n| product * n }
end

ary = (1..5)
a = ary.count               #=> 4
b = ary.count(2)            #=> 2
c = ary.count(&:even?) #=> 3
print a, b, c
