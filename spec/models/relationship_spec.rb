require 'rails_helper'

RSpec.describe Relationship, type: :model do
  let(:user) { create(:user) }
  let(:second_user) { create(:user) }
  subject { create(:relationship, follower: user, followed: second_user) }

  context 'associations' do
    it { is_expected.to belong_to(:follower).class_name('User') }
    it { is_expected.to belong_to(:followed).class_name('User') }
    it do
      should define_enum_for(:status)
        .with_values(pending: 0, accepted: 1)
    end
  end

  context 'callbacks' do
    it 'sets status before validation' do
      actual_status = second_user.private? ? 'pending' : 'accepted'
      expect(subject.status).to eq(actual_status)
    end
  end

  context 'column specifications' do
    it { is_expected.to have_db_column(:follower_id).of_type(:integer) }
    it { is_expected.to have_db_column(:followed_id).of_type(:integer) }
    it { is_expected.to have_db_column(:status).of_type(:integer) }
    it { is_expected.to have_db_index(:follower_id) }
    it { is_expected.to have_db_index(:followed_id) }
    it { is_expected.to have_db_index(%i[follower_id followed_id]) }
    it_behaves_like 'have timestamps'
  end
end
