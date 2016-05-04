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

  def angular_momentum
    @v.magnitude * @mass * @position.magnitude
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
    Math.hypot(x - other_planet.x, y - other_planet.y)
  end

  def distance_to_sun
    Math.hypot(x, y)
  end

  def angle
    w = Vector[1, 0]
    angle = Math.atan2(@v[1], @v[0]) - Math.atan2(w[1], w[0])
    angle += (2*Math::PI) if angle < 0
    return angle
  end

  def collide_with(other_planet)
    return if @id == 0 || other_planet.id == 0

    # Obtain new position
    new_pos = (@position * @mass + other_planet.position * other_planet.mass) / (@mass + other_planet.mass)

    # Obtain new mass
    new_mass = @mass + other_planet.mass

    # Obtain new velocity
    tangential_module = (angular_momentum + other_planet.angular_momentum) / (@mass * @position.magnitude)
    tangential_velocity = ((Vector[0, 0] - @position).normalize) * tangential_module

    radial_velocity = (radial * @mass + other_planet.radial * other_planet.mass) / (@mass + other_planet.mass)

    new_vel = tangential_velocity + radial_velocity

    # Asignment
    @position = new_pos
    @mass = new_mass
    @v = new_vel
  end

  def radial
    radial_versor = (Vector[0, 0] - @position).normalize
    q = Vector[radial_versor[0] * @v[0], radial_versor[1] * @v[1]]
    Vector[radial_versor[0] * q[0], radial_versor[1] * q[1]]
  end

  # Energy methods
  def potential_energy
    - G * @mass * SUN_MASS / @position.magnitude
  end

  def cinetic_energy
    0.5 * @mass * @v.magnitude**2
  end

  # Color methods
  def red
    if @id == 0 then
      255
    else
      (2 / Math::PI) * angle - (angle**2 / (Math::PI ** 2))
    end
  end

  def green
    if @id == 0 then
      255
    else
      1 - (angle / (2 * Math::PI))
    end
  end

  def blue
    if @id == 0 then
      0
    else
      (angle / (2 * Math::PI))
    end
  end

end