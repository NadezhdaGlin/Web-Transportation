require 'rails_helper'
require 'factory_bot_rails'

RSpec.describe Cargos::DistanceWidget, type: :wiget do
  let!(:org) { create :organization }
  let!(:user) { create :user, organization_id: org.id }

  let!(:cargo) { create :cargo, user_id: user.id }
  let!(:cargo_min) { create :cargo, user_id: user.id, distance: '564.1' }
  let!(:cargo_max) { create :cargo, user_id: user.id, distance: '1508.2' }

  subject(:call) { described_class.call(Organization.last.id, params) }

  context '#call' do
    context 'when params is distance min' do
      let!(:params) { :min }

      it 'returns cargo with min distance' do
        expect(call[:data]).to eq("#{cargo_min.distance} km")
      end
    end

    context 'when params is nil' do
      subject(:call) { described_class.call(Organization.last.id) }
      it 'returns cargo with min distance' do
        expect(call[:data]).to eq("#{cargo_min.distance} km")
      end
    end

    context 'when params is distance max' do
      let!(:params) { :max }

      it 'returns cargo with max distance' do
        expect(call[:data]).to eq("#{cargo_max.distance} km")
      end
    end
  end
end
