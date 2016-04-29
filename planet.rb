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
    @position.x = @position.x + time * @vx + (time**2/mass) * f * Math.cos(angle)
    @position.y = @position.y + time * @vy + (time**2/mass) * f * Math.sin(angle)

    f_new = force
    @vx = @vx + (time/2*mass)*(f*Math.cos(angle) + f_new*Math.cos(angle))
    @vy = @vy + (time/2*mass)*(f*Math.sin(angle) + f_new*Math.sin(angle))
  end

  def force
    G * mass * SUN_MASS / position.distance_to(Point.new(0, 0))
  end

  def angle
    Math.atan2(y, x)
  end
end