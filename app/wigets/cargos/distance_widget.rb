module Cargos
  class DistanceWidget < DefaultWidget
    def self.call(org_id, func = :min)
      new(org_id).send(func)
    end

    def min
      cargo = @relation.order(:distance).first
      output(cargo, 'Min')
    end

    def max
      cargo = @relation.order(:distance).last
      output(cargo, 'Max')
    end

    def output(cargo, grade)
      { text: "#{grade} distance cargo equal:", data: "#{cargo.distance} km" }
    end
  end
end
