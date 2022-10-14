require 'rails_helper'

RSpec.describe Like, type: :model do
  subject { create(:like, :for_post) }

  context 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:likeable) }
  end

  context 'validations' do
    it { should validate_uniqueness_of(:user_id).scoped_to(%i[likeable_id likeable_type]).ignoring_case_sensitivity }
  end

  context 'column specifications' do
    it { is_expected.to have_db_column(:likeable_type).of_type(:string).with_options(null: false) }
    it { is_expected.to have_db_column(:likeable_id).of_type(:integer).with_options(null: false) }
    it { is_expected.to have_db_column(:user_id).of_type(:integer).with_options(null: false) }
    it { is_expected.to have_db_index(%i[likeable_type likeable_id user_id]) }
    it { is_expected.to have_db_index(%i[likeable_type likeable_id]) }
    it { is_expected.to have_db_index(:user_id) }

    it_behaves_like 'have timestamps'
  end
end
