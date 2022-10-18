module Cargos
  class PriceWidget < DefaultWidget
    def self.call(org_id, func = :sum)
      new(org_id).send(func)
    end

    def sum
      cargo = @relation.map(&:price).sum
      { text: 'Sum of all price cargos:', data: "#{cargo} RUB" }
    end

    def average
      cargo = @relation.map(&:price).sum / @relation.count
      { text: 'Average of all price cargos:', data: "#{cargo} RUB" }
    end
  end
end
