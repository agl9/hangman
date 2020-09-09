# frozen_string_literal: true

# module to serialie and unserialize the files
module Serialization
  def serialize
    game = {}
    instance_variables.map do |state|
      game[state] = instance_variable_get(state)
    end
    JSON.dump(game)
  end

  def unserialize(string)
    game = JSON.parse(string)
    game.keys.each do |state|
      instance_variable_set(state, game[state])
    end
  end
end
