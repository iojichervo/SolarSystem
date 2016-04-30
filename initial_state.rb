#!/usr/bin/env ruby

require 'set'
require 'matrix'
require './planet.rb'

# Generate the random particles and the sun
def generate_planets
  particles = Set.new

  sun = Planet.new(R, SUN_MASS, Vector[0,0], Vector[0, 0])
  particles.add(sun)

  planets_mass = SUN_MASS / N.to_f
  angular_momentum = get_angular_momentum(planets_mass)

  N.times do
    position = random_position
    velocity = initial_velocity(angular_momentum, position, planets_mass)
    new_particle = Planet.new(R, planets_mass, position, velocity)
    particles.add(new_particle)
  end

  return particles
end

def get_angular_momentum(mass)
  μ = (mass * SUN_MASS) / (mass + SUN_MASS)
  energy = -10**30
  r = MIN_DISTANCE_SUN * 1.005
  f = (G * mass * SUN_MASS) / r
  return Math.sqrt(2 * μ * r**2 * (energy + f))
end

# Return a new position for a new planet
def random_position
  random_angle = rand(0..2*Math::PI)
  random_distance = rand(MIN_DISTANCE_SUN..MAX_DISTANCE_SUN.to_f)
  x = random_distance * Math.cos(random_angle)
  y = random_distance * Math.sin(random_angle)
  return Vector[x, y]
end

# Returns the tangential velocity of the planet based on a common angular momentum
def initial_velocity(angular_momentum, position, mass)
  v = angular_momentum / (position.magnitude * mass)

  cos = Math.cos(-Math::PI / 2)
  sin = Math.sin(-Math::PI / 2)
  x = position[0]
  y = position[1]
  tangent = Vector[cos * x - sin * y, sin * x - cos * y]
  return tangent.normalize * v
end