require 'rails_helper'
require 'factory_bot_rails'

RSpec.describe CargoPolicy, type: :policy do
  let!(:org) { create :organization }
  let!(:another_org) { create :organization, name_org: 'BlahBlah' }

  let!(:user_orgadmin) { create :user, organization_id: org.id }
  let!(:user_operator) { create :user, role: 'operator', organization_id: org.id }
  let!(:user) { create :user, role: nil, organization_id: nil }
  let!(:user_another_org) { create :user, organization_id: another_org.id }

  let!(:cargo1) { create :cargo, user_id: user_orgadmin.id }
  let!(:cargo2) { create :cargo, user_id: user_operator.id }
  let!(:cargo) { create :cargo, user_id: user.id }
  let!(:cargo_anot_org) { create :cargo, user_id: user_another_org.id }

  describe CargoPolicy do
    subject(:record) { described_class }

    permissions :show?, :edit?, :update? do
      it 'grants access if the user is an orgadmin and operator' do
        expect(record).to permit(user_orgadmin, cargo1)
        expect(record).to permit(user_orgadmin, cargo2)
        expect(record).to permit(user_operator, cargo2)
      end

      it 'operator cant view the records of other users' do
        expect(record).not_to permit(user_operator, cargo1)
      end

      it 'access denied if user anoter org' do
        expect(record).not_to permit(user_another_org, cargo1)
      end
    end

    permissions :index?, :new?, :create? do
      it 'grants index, new, create access if the user is an orgadmin and operator' do
        expect(record).to permit(user_orgadmin, cargo1)
        expect(record).to permit(user_operator, cargo2)
      end
    end

    permissions :index? do
      it 'access denied if user has no role' do
        expect(record).to permit(user, cargo)
      end
    end
  end
end
