#!/usr/bin/env ruby

require './initial_state.rb'
require 'matrix'

def simulation
  planets = generate_planets
  print_next_state(planets, 'w', 0)

  actual_time = 0
  while actual_time < SIMULATION_END_TIME do
#    collapse(planets)
    move(planets, SIMULATION_DELTA_TIME)
    actual_time += SIMULATION_DELTA_TIME

    if ((next_frame(actual_time)*10) / (FRAME_DELTA_TIME*10)) % 1 == 0 then # To avoid float error
      print_next_state(planets, 'a', next_frame(actual_time))
    end
  end
end

# Moves all the planets a certain time
def move(planets, time)
  planets.each do |p|
    p.move(time) if p.id != 0
  end
end

def collapse(planets)
  planets.each do |planet|
    planets.each do |other_planet|
      if planet.id != other_planet.id && planet.distance_to(other_planet) < CLOSE_DISTANCE then
        planets.delete(other_planet)
        planet.collide_with(other_planet)
      end
    end
  end
end

# Returns the next frame of a certain time
def next_frame(time)
  return (time.round(1) - time > 0 ? time.round(1) : time.round(1) + FRAME_DELTA_TIME).round(1)
end

# Prints each planet at a given time
def print_next_state(planets, mode, second)
  Dir.mkdir("out") unless File.exists?("out")
  file = File.open("./out/planets.txt", mode)
  file.write("#{planets.size + 4}\n") # 4 for the invisible ones at the corners
  file.write("#{second}\n")
  scale_reduction = MIN_DISTANCE_SUN
  planets.each do |planet|
    file.write("#{planet.x/scale_reduction} #{planet.y/scale_reduction}\n")
  end
  file.write("#{MAX_DISTANCE_SUN/scale_reduction} #{MAX_DISTANCE_SUN/scale_reduction}\n")
  file.write("#{MAX_DISTANCE_SUN/scale_reduction} #{-MAX_DISTANCE_SUN/scale_reduction}\n")
  file.write("#{-MAX_DISTANCE_SUN/scale_reduction} #{MAX_DISTANCE_SUN/scale_reduction}\n")
  file.write("#{-MAX_DISTANCE_SUN/scale_reduction} #{-MAX_DISTANCE_SUN/scale_reduction}\n")
  file.close
end

N = 100 # Planets Amount at the start
R = 0
SUN_MASS = 2*(10**30)
G = 6.693*(10**-11)
MAX_DISTANCE_SUN = 10**10
MIN_DISTANCE_SUN = 10**9
CLOSE_DISTANCE = 10**6
SIMULATION_DELTA_TIME = 1
SIMULATION_END_TIME = 5000
K = 50
FRAME_DELTA_TIME = K * SIMULATION_DELTA_TIME

simulation