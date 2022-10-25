require 'rails_helper'
require 'factory_bot_rails'

RSpec.describe Cargos::CountWidget, type: :wigets do
  let!(:org) { create :organization }
  let!(:user1) { create :user, organization_id: org.id }
  let!(:user2) { create :user, organization_id: org.id }

  let!(:cargo1) { create :cargo, user_id: user1.id }
  let!(:cargo2) { create :cargo, user_id: user1.id }

  subject(:call) { described_class.call(Organization.last.id, params) }
  context '#call' do
    context 'when params is all' do
      let(:params) { :all }
      it 'returns size cargos' do
        expect(call[:data]).to eq(Cargo.all.size)
      end
    end

    context 'when params is nil' do
      subject(:call) { described_class.call(Organization.last.id) }
      it 'returns size cargos' do
        expect(call[:data]).to eq(Cargo.all.size)
      end
    end

    context 'when params is sorted' do
      let(:params) { :sorted }
      it 'returns users with size cargos' do
        expect(call[:data]).to include("User #{user1.id} have #{user1.cargos.size} cargos")
      end
    end
  end
end
