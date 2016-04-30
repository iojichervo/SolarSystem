#!/usr/bin/env ruby

require 'set'

class Planet
  attr_reader :id, :radius, :neighbors, :mass
  attr_accessor :position, :v

  @@ids = 0

  def initialize(radius, mass, position, velocity)
    @id = @@ids
    @@ids += 1
    @radius = radius
    @mass = mass
    @position = position
    @v = velocity
    @neighbors = Set.new
  end

  def ==(other)
    self.id == other.id
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
    @position[0]
  end

  def y
    @position[1]
  end

  def vx
    @v[0]
  end

  def vy
    @v[1]
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
    @position = @position + time * @v + (time**2/mass) * f

    f_new = force
    @v = @v + (time / (2*mass)) * (f + f_new)
  end

  # Gravitational force
  def force
    @position.normalize * (-G * mass * SUN_MASS / (@position.magnitude**2))
  end

  def distance_to(other_planet)
    (position - other_planet.position).magnitude
  end

  # WIP
  def collide_with(other_planet)
    new_mass = @mass + other_planet.mass

    # Obtain new position
    @position.x *= @mass
    @position.y *= @mass

    other_position = other_planet.position
    other_position.x *= other_planet.mass
    other_position.y *= other_planet.mass

    @position.x += other_position.x
    @position.y += other_position.y

    @position.x /= new_mass
    @position.y /= new_mass

    # Obtain new mass
    @mass = new_mass

    # Obtain new velocity
    new_angular_momentum = L + other_position.L
    new_vel_tan_val = new_angular_momentum / (@mass * @position.distance_to_origin)

    new_vel_tan = Point.new(-@position.x, -@position.y)
    new_vel_tan.multiply(1.0 / new_vel_tan.distance_to_origin).multiply(new_vel_tan_val)
  end
end