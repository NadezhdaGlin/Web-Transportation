# frozen_string_literal: true

require 'rails_helper'
require 'factory_bot_rails'

RSpec.describe StatesJob, type: :job do
  let!(:processing_cargo) { create :cargo }
  let!(:delivering_cargo) { create :delivering_cargo }
  let!(:delivered_cargo) { create :delivered_cargo }
  subject(:perform) { described_class.perform_now }

  it 'changes cargo status' do
    perform
    expect(processing_cargo.reload.status).to eq('delivering')
    expect(delivering_cargo.reload.status).to eq('delivered')
    expect(delivered_cargo.reload.status).to eq('delivered')
  end
end
