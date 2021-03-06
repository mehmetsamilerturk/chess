# frozen_string_literal: true

module BasicSerializable
  # should point to a class; change to a different
  # class (e.g. MessagePack, JSON, YAML) to get a different
  # serialization
  @@serializer = YAML

  def serialize
    obj = {}
    instance_variables.map do |var|
      obj[var] = instance_variable_get(var)
    end

    @@serializer.dump obj
  end

  def unserialize(string)
    obj = YAML.safe_load(string, permitted_classes: [Board, Symbol, Rook, Bishop, Piece, Knight, King, Queen, Pawn])
    obj.each_key do |key|
      instance_variable_set(key, obj[key])
    end
  end
end
