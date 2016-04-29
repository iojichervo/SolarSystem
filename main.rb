#!/usr/bin/env ruby

require './initial_state.rb'

def simulation
  planets = generate_planets
  print_next_state(planets, 'w', 0)

  actual_time = 0
  i = 0
  while i < FRAMES do
    move(planets, 0.1)
    actual_time += 0.1

    print_next_state(planets, 'a', actual_time)
    i += 1
  end
end

# Moves all the planets a certain time
def move(planets, time)
  planets.each do |p|
    p.move(time)
  end
end

# Prints each planet at a given time
def print_next_state(planets, mode, second)
  Dir.mkdir("out") unless File.exists?("out")
  file = File.open("./out/planets.txt", mode)
  file.write("#{N + 1 + 4}\n") # 1 for the sun, 4 for the invisible ones at the corners
  file.write("#{second}\n")
  planets.each do |planet|
    file.write("#{planet.x} #{planet.y} #{planet.vx} #{planet.vy} #{planet.radius}\n")
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
MAX_DISTANCE_SUN = 10
MIN_DISTANCE_SUN = 1
FRAMES = 100

simulation