require 'rails_helper'
require 'factory_bot_rails'

RSpec.describe Cargos::DefaultWidget, type: :wiget do
  let!(:org) { create :organization }
  let!(:user) { create :user, organization_id: org.id }
  let!(:cargo1) { create :cargo, user_id: user.id }
  let!(:cargo2) { create :cargo, user_id: user.id }

  context '.initialize' do
    context 'when param group_by present' do
      subject(:init) { described_class.new(Organization.last.id, :user_id) }
      it 'assign right relation' do
        expect(init.relation).to eq(Cargo.org_by(Organization.last.id, :user_id))
      end
    end

    context 'when param group_by is nil' do
      let(:params) { Organization.last.id }
      subject(:init) { described_class.new(params) }
      it 'assign relation' do
        expect(init.relation).to eq(Cargo.org_by(Organization.last.id))
      end
    end
  end

  context '#call' do
    subject(:call) { described_class.call }
    it 'return error' do
      expect { call }.to raise_error("Can't call default widgets. Use descendant call")
    end
  end
end
