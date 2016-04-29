#!/usr/bin/env ruby

class Point
  attr_accessor :x, :y

  def initialize(x, y)
    @x = x
    @y = y
  end

  def eql?(other)
    self.x == other.x && self.y == other.y
  end

  def hash
    x.hash + y.hash
  end

  def to_s()
    "(#{@x}, #{@y})"
  end

  # Calculates the Euclidean distance between the point and other_point.
  def distance_to(other_point)
    Math.hypot((@x - other_point.x), (@y - other_point.y))
  end
end