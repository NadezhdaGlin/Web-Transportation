# frozen_string_literal: true

require 'rails_helper'
require 'factory_bot_rails'

RSpec.describe Cargos::DestroyCargo, type: :interaction do
  context '#destroy' do
    let!(:user) { create :user }
    let!(:cargo) { create :cargo }
    let(:params) { { cargo: cargo, user: user } }
    subject(:destroy_cargo) { described_class.run(params) }

    context 'when cargo exist' do
      it 'destroy cargo' do
        expect { destroy_cargo }.to change(Cargo, :count).by(-1)
      end
    end

    context 'when cargo doesnt exist' do
      let(:params) { { cargo: Cargo.find(-1) } }
      subject(:destroy_cargo_not_exists) { described_class.run(params) }

      it 'raise record_not_found error' do
        expect { destroy_cargo_not_exists }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
