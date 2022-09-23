# frozen_string_literal: true

require 'rails_helper'
require 'factory_bot_rails'

RSpec.describe Cargos::CreateCargo, type: :interaction do
  context '#create' do
    let!(:user) { create :user }
    subject(:outcome) { described_class.run(params) }
    subject(:invalid_outcome) { described_class.run(invalid_params) }

    context 'when data is correct' do
      let!(:params) { attributes_for :cargo, user: user }

      it 'returns creates cargo' do
        VCR.use_cassette('Interaction_for_cargo') do
          expect { outcome }.to change(Cargo, :count).by(1)
        end
      end
    end

    context 'when data invalid' do
      let!(:params) { attributes_for :cargo, height: -1, user: user }
      let!(:invalid_params) { attributes_for :cargo, phone: '123', user: user }

      it 'returns raise' do
        VCR.use_cassette('Interaction_for_cargo') do
          expect { outcome }.to raise_error('Values cannot be negative')
        end
      end

      it 'cargo is not created' do
        VCR.use_cassette('Interaction_for_cargo') do
          expect { invalid_outcome }.to change(Cargo, :count).by(0)
        end
      end
    end
  end
end
