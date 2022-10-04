require 'rails_helper'

RSpec.describe Comment, type: :model do
  context 'associations' do
    it { is_expected.to belong_to(:post) }

    it { is_expected.to belong_to(:user) }

    it { is_expected.to belong_to(:parent).class_name('Comment').optional }

    it do
      is_expected.to have_many(:replies).
      class_name('Comment').
      with_foreign_key('parent_id').
      dependent(:destroy).
      inverse_of(:parent)
    end

    it { is_expected.to have_many(:likes).dependent(:destroy) }

  end

  context 'validations' do
    it { is_expected.to validate_presence_of(:body) }

    it { is_expected.to validate_length_of(:body).is_at_most(220) }

  end

  context 'column specifications' do
    it { is_expected.to have_db_column(:body).of_type(:string).with_options(limit: 220, null: false)}

    it { is_expected.to have_db_column(:user_id).of_type(:integer).with_options(null: false) }

    it { is_expected.to have_db_column(:post_id).of_type(:integer).with_options(null: false) }

    it { is_expected.to have_db_column(:parent_id).of_type(:integer) }

    it { is_expected.to have_db_column(:created_at).of_type(:datetime).with_options(precision: 6, null: false) }

    it { is_expected.to have_db_column(:updated_at).of_type(:datetime).with_options(precision: 6, null: false) }

    it { is_expected.to have_db_index(:user_id)}

  end

end
