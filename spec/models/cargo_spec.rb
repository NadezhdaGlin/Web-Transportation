# frozen_string_literal: true

require 'rails_helper'
require 'factory_bot_rails'

RSpec.describe Cargo, type: :model do
  context 'aasm' do
    let(:processing_cargo) { build :cargo }
    let(:delivering_cargo) { build :delivering_cargo }
    let(:delivered_cargo) { build :delivered_cargo }

    context 'status for processing' do
      it 'have state processing' do
        expect(processing_cargo).to have_state(:processing)
      end

      it 'from processing to delivering' do
        expect(processing_cargo).to transition_from(:processing)
          .to(:delivering).on_event(:cargo_processing)
      end

      it 'does not have transition to delivered' do
        expect(processing_cargo).not_to transition_from(:processing)
          .to(:delivered).on_event(:cargo_processing)
      end

      it 'allow only processing' do
        expect(processing_cargo).to allow_event :cargo_processing
        expect(processing_cargo).to_not allow_event :cargo_delivery
      end
    end

    context 'status for delivering' do
      it 'have state delivering' do
        expect(delivering_cargo).to have_state(:delivering)
      end

      it 'from delivering to delivered' do
        expect(delivering_cargo).to transition_from(:delivering)
          .to(:delivered).on_event(:cargo_delivery)
      end

      it 'does not have transition to processing' do
        expect(delivering_cargo).not_to transition_from(:delivering)
          .to(:processing).on_event(:cargo_delivery)
      end

      it 'allow only delivering' do
        expect(delivering_cargo).to allow_event :cargo_delivery
        expect(delivering_cargo).to_not allow_event :cargo_processing
      end
    end

    context 'status for delivered' do
      it 'have state delivered' do
        expect(delivered_cargo).to have_state(:delivered)
      end

      it 'not allowed any actions' do
        expect(delivered_cargo).to_not allow_event :cargo_delivery
        expect(delivered_cargo).to_not allow_event :cargo_processing
      end
    end
  end
end
