#!/usr/bin/env ruby

require './initial_state.rb'

def simulation
  planets = generate_planets
  print_next_state(planets, 'w', 0)
end

# Prints each particle at a given time
def print_next_state(particles, mode, second)
  Dir.mkdir("out") unless File.exists?("out")
  file = File.open("./out/particles.txt", mode)
  file.write("#{N + 1 + 4}\n") # 1 for the sun, 4 for the invisible ones at the corners
  file.write("#{second}\n")
  particles.each do |particle|
    file.write("#{particle.x} #{particle.y} #{particle.vx} #{particle.vy} #{particle.radius}\n")
  end
  file.write("#{MAX_DISTANCE_SUN} #{MAX_DISTANCE_SUN} 0 0 0\n")
  file.write("#{MAX_DISTANCE_SUN} #{-MAX_DISTANCE_SUN} 0 0 0\n")
  file.write("#{-MAX_DISTANCE_SUN} #{MAX_DISTANCE_SUN} 0 0 0\n")
  file.write("#{-MAX_DISTANCE_SUN} #{-MAX_DISTANCE_SUN} 0 0 0\n")
  file.close
end

N = 1000 # Planets Amount
R = 0
SUN_MASS = 2*(10**30)
G = 6.693*(10**-11)
MAX_DISTANCE_SUN = 10**10
MIN_DISTANCE_SUN = 10**9

simulation