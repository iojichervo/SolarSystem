#!/usr/bin/env ruby

require './initial_state.rb'
require './cell_index_method.rb'
require 'matrix'

def simulation
  planets = generate_planets
  m = 10**4 - 1
  state = State.new(MAX_DISTANCE_SUN, MAX_DISTANCE_SUN / m.to_f, planets.size, planets)
  print_next_state(planets, 'w', 0)

  actual_time = 0
  while actual_time < SIMULATION_END_TIME do
    #cim_main(state, m, CLOSE_DISTANCE)
    #collapse(planets)
    calculate_energy(planets)
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
    planet.neighbors.each do |other_planet|
      if planet != other_planet && planet.distance_to(other_planet) < CLOSE_DISTANCE then
        planets.delete(other_planet)
        planet.collide_with(other_planet)
      end
    end
  end
end

def calculate_energy(planets)
  cin_energy = 0
  pot_energy = 0
  planets.each do |p|
    if p.id != 0 then # Don't add the energy of the sun
      cin_energy += p.cinetic_energy
      pot_energy += p.potential_energy
    end
  end
  #puts "Cin: #{cin_energy}"
  #puts "Pot: #{pot_energy}"
  puts "Energy: #{pot_energy + cin_energy}"
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
    file.write("#{planet.x/scale_reduction} #{planet.y/scale_reduction} #{planet.vx/scale_reduction} #{planet.vy/scale_reduction}\n")
  end
  file.write("#{MAX_DISTANCE_SUN/scale_reduction} #{MAX_DISTANCE_SUN/scale_reduction} 0 0\n")
  file.write("#{MAX_DISTANCE_SUN/scale_reduction} #{-MAX_DISTANCE_SUN/scale_reduction} 0 0\n")
  file.write("#{-MAX_DISTANCE_SUN/scale_reduction} #{MAX_DISTANCE_SUN/scale_reduction} 0 0\n")
  file.write("#{-MAX_DISTANCE_SUN/scale_reduction} #{-MAX_DISTANCE_SUN/scale_reduction} 0 0\n")
  file.close
end

N = 100 # Planets amount at the start
R = 0
SUN_MASS = 2*(10**30)
G = 6.6741*(10**-11)
MAX_DISTANCE_SUN = 10**10
MIN_DISTANCE_SUN = 10**9
CLOSE_DISTANCE = 10**6
SIMULATION_DELTA_TIME = 20
SIMULATION_END_TIME = 100000
K = 50
FRAME_DELTA_TIME = K * SIMULATION_DELTA_TIME

simulation