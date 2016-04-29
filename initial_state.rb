#!/usr/bin/env ruby

require 'set'
require './planet.rb'
require './point.rb'

# Generate the random particles and the sun
def generate_planets
  particles = Set.new

  sun = Planet.new(R, SUN_MASS, Point.new(0,0), 0, 0)
  particles.add(sun)

  planets_mass = SUN_MASS / N.to_f
  angular_momentum = -0.1

  N.times do
    position = random_position
    velocity = initial_velocity(angular_momentum, position, planets_mass)
    new_particle = Planet.new(R, planets_mass, position, velocity.x, velocity.y)
    particles.add(new_particle)
  end

  return particles
end

# Return a new position for a new planet
def random_position
  random_angle = rand(0..2*Math::PI)
  random_distance = rand(MIN_DISTANCE_SUN..MAX_DISTANCE_SUN.to_f)
  x = random_distance * Math.cos(random_angle)
  y = random_distance * Math.sin(random_angle)
  return Point.new(x, y)
end

# Returns the tangential velocity of the planet based on a common angular momentum
def initial_velocity(angular_momentum, position, mass)
  v = angular_momentum / (position.distance_to_origin * mass)

  cos = Math.cos(Math::PI / 2)
  sin = Math.sin(Math::PI / 2)
  tangent = Point.new(cos * position.x - sin * position.y, sin * position.x - cos * position.y)
  tangent.multiply(1.0 / tangent.distance_to_origin).multiply(v)

  return tangent
end