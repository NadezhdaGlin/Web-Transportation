module Cargos
  class CountWidget < DefaultWidget
    def self.call(org_id, func = :all)
      arg = func == :sorted ? :user_id : nil
      new(org_id, arg).send(:count)
    end

    def count
      responce = output(@relation.count)
    end

    def output(input)
      if input.instance_of?(Hash)
        result = input.each_with_object([]) do |(id, quantity), result|
          result << "User #{id} have #{quantity} cargos"
        end
        { text: 'Count of packages by: ', data: "#{result.join(', ')}" }
      else
        { text: 'Count of packages by users', data: input.to_s }
      end
    end
  end
end
