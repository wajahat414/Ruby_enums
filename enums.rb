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
end

# a = { cat: 1, bat: 33, fat: 99 }
# a.my_each { |k, v| puts("#{k}:#{v}") }
# a=(1..7)
# a.my_each {|k| puts k}
a = [1, 2, 3, 4]
a.my_each { |k| puts k }
