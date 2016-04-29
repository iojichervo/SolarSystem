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

  N.times do
    position = random_position
    velocity = transform_tangential_velocity(5, position)
    new_particle = Planet.new(R, planets_mass, position, velocity[0], velocity[1])
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

=begin
# Tangential velocity in x and y
def transform_tangential_velocity(vt, position)
  theta = Math.atan2(position.y, position.x)
  alpha = (Math::PI / 2) - theta
  vx = vt * Math.cos(alpha)
  vy = vt * Math.sin(alpha)

  error = 0.00001
  vx = 0 if vx.abs < error
  vy = 0 if vy.abs < error

  return [vx, vy]
end
=end