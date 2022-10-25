class StatesJob < ActiveJob::Base
  def perform
    cargos = Cargo.all

    cargos.each do |cargo|
      next_event = cargo.aasm.events(permitted: true).first&.name
      cargo.aasm.fire!(next_event) if next_event.present?
    end
  end
end
