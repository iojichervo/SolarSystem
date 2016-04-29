#!/usr/bin/env ruby

require 'set'

class Planet
  attr_reader :id, :radius, :neighbors, :mass
  attr_accessor :position, :vx, :vy

  @@ids = 0

  def initialize(radius, mass, position, vx, vy)
    @id = @@ids
    @@ids += 1
    @radius = radius
    @mass = mass
    @position = position
    @vx = vx
    @vy = vy
    @neighbors = Set.new
  end

  def eql?(other)
    self.id == other.id
  end

  def hash
    id
  end

  def to_s
    "id: #{@id}, radius: #{@radius}, mass: #{@mass}, position: #{@position}"
  end

  def x
    @position.x
  end

  def y
    @position.y
  end

  def add_neighbor(particle)
    @neighbors.add(particle)
  end

  def reset_neighbors
    @neighbors = Set.new
  end

  # Movement made using Velocity-Verlet algorithm
  def move(time)
    f = force
    a = angle
    @position.x = @position.x + time * @vx + (time**2/mass) * f * Math.cos(a)
    @position.y = @position.y + time * @vy + (time**2/mass) * f * Math.sin(a)

    f_new = force
    a_new = angle
    @vx = @vx + (time/(2*mass))*(f*Math.cos(a) + f_new*Math.cos(a_new))
    @vy = @vy + (time/(2*mass))*(f*Math.sin(a) + f_new*Math.sin(a_new))
  end

  def force
    G * mass * SUN_MASS / (position.distance_to_origin**2)
  end

  def angle
    Math.atan2(y, x)
  end
end