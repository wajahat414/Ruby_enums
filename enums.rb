# rubocop: disable Metrics/ModuleLength, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity

# Description/Explanation of module enums
module Enumerable
  #:nodoc:
  def my_each(_block = 0, index = 0)
    return to_enum unless block_given?

    while index < to_a.length
      yield(to_a[index])
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
        arr[index] = k
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
      elsif (flag = [Integer, Float, String, Numeric].include?(pattern))
        return false unless check?(k, pattern, flag)
      else
        return false unless pattern.to_s.include?(k.to_s)
      end
    end
    true
  end

  def my_any?(pattern = nil, flag: false)
    my_each do |k|
      if block_given?
        return true if yield(k)
      elsif (flag = [Integer, Float, String, Numeric].include?(pattern))
        return true if check?(k, pattern, flag)
      elsif pattern.to_s.include?(k.to_s)
        return true
      end
    end
    false
  end

  def my_none?(pattern = nil, flag: false)
    my_each do |k|
      if block_given?
        return false if yield(k)
      elsif (flag = [Integer, Float, String, Numeric].include?(pattern))
        return false if check?(k, pattern, flag)
      elsif pattern.to_s.include?(k.to_s)
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

  def my_inject(vos = nil, ops = nil)
    mem = vos.public_send(ops, to_a[0]) if ops
    arr = to_a
    my_each_with_index do |k, i|
      mem = to_a[0] if i.zero? && !ops
      if ['+', '-', '/', '*'].include?(vos.to_s)
        mem = mem.public_send(vos, arr[i + 1]) if i < arr.to_a.length - 1
      elsif ops
        mem = mem.public_send(ops, arr.to_a[i + 1]) if i < arr.to_a.length - 1

      end
      mem = yield(mem, k) if block_given? && !i.zero?
    end
    mem = yield(mem, vos) if block_given? && vos
    yield unless block_given? || vos
    mem
  end

  def my_map(my_proc = nil)
    arr = Array.new(to_a.length)
    to_a.my_each_with_index do |item, index|
      if my_proc
        arr[index] = my_proc.call(item)
      else
        arr[index] = yield(item) if block_given?
        return to_enum unless block_given?
      end
    end
    arr
  end
end

def multiply_els(arr)
  arr.my_inject(:*)
end
# rubocop: enable Metrics/ModuleLength, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
