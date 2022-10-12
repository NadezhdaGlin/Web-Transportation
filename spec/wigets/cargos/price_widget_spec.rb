require 'rails_helper'
require 'factory_bot_rails'

RSpec.describe Cargos::PriceWidget, type: :wiget do
  let!(:org) { create :organization }
  let!(:user) { create :user, organization_id: org.id }

  let!(:cargo) { create :cargo, user_id: user.id }
  let!(:cargo1) { create :cargo, user_id: user.id, price: '2954' }
  let!(:cargo2) { create :cargo, user_id: user.id, price: '591' }

  subject(:call) { described_class.call(Organization.last.id, params) }

  context '#call' do
    context 'when params is sum all price cargos' do
      let(:params) { :sum }
      it 'returns sum' do
        expect(call[:data]).to eq('4896 RUB')
      end
    end

    context 'when params is nil' do
      subject(:call) { described_class.call(Organization.last.id) }
      it 'returns sum' do
        expect(call[:data]).to eq('4896 RUB')
      end
    end

    context 'when params is average all price' do
      let(:params) { :average }
      it 'returns average' do
        expect(call[:data]).to eq('1632 RUB')
      end
    end
  end
end
