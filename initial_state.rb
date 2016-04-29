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
    #vx = rand(-0.1..0.1)
    #vy = rand(-0.1..0.1)
    vx = 0
    vy = 0
    new_particle = Planet.new(R, planets_mass, random_position(particles), vx, vy)
    particles.add(new_particle)
  end

  return particles
end

# Return a new position for a new planet
def random_position(particles)
  random_angle = rand(0..2*Math::PI)
  random_distance = rand(MIN_DISTANCE_SUN..MAX_DISTANCE_SUN.to_f)
  x = random_distance * Math.cos(random_angle)
  y = random_distance * Math.sin(random_angle)
  return Point.new(x, y)
end