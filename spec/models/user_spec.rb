require 'rails_helper'

RSpec.describe User, type: :model do
  context 'associations' do
    it { is_expected.to have_one_attached(:avatar) }
    it { is_expected.to have_many(:posts).dependent(:destroy) }
    it { is_expected.to have_many(:stories).dependent(:destroy) }
    it { is_expected.to have_many(:comments).dependent(:destroy) }
    it { is_expected.to have_many(:likes).dependent(:destroy) }

    it do
      is_expected.to have_many(:active_relationships)
        .class_name('Relationship')
        .with_foreign_key('follower_id')
        .dependent(:destroy)
        .inverse_of(:follower)
    end

    it do
      is_expected.to have_many(:passive_relationships)
        .class_name('Relationship')
        .with_foreign_key('followed_id')
        .dependent(:destroy)
        .inverse_of(:followed)
    end

    it do
      is_expected.to have_many(:following)
        .through(:active_relationships)
        .source(:followed)
    end

    it do
      is_expected.to have_many(:followers)
        .through(:passive_relationships)
        .source(:follower)
    end

    it do
      is_expected.to have_many(:pending_follows)
        .through(:active_relationships)
        .source(:followed)
    end

    it do
      is_expected.to have_many(:follow_requests)
        .through(:passive_relationships)
        .source(:follower)
    end
  end

  context 'validations' do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
    it { is_expected.to validate_presence_of(:username) }
    it { is_expected.to validate_uniqueness_of(:username) }
    it { is_expected.to allow_value('John123').for(:username) }

    it do
      create(:user, email: 'John123@example.com')
      expect { create(:user, username: 'John123@example.com') }
        .to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  context 'column specifications' do
    it { is_expected.to have_db_column(:username).of_type(:string).with_options(null: false) }
    it { is_expected.to have_db_column(:email).of_type(:string).with_options(null: false) }
    it { is_expected.to have_db_column(:fullname).of_type(:string) }
    it { is_expected.to have_db_column(:bio).of_type(:string) }
    it { is_expected.to have_db_column(:website).of_type(:string) }
    it { is_expected.to have_db_column(:is_private).of_type(:boolean).with_options(default: false) }
    it { is_expected.to have_db_column(:encrypted_password).of_type(:string).with_options(null: false, default: '') }
    it { is_expected.to have_db_column(:reset_password_token).of_type(:string) }
    it { is_expected.to have_db_column(:reset_password_sent_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:remember_created_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:remember_created_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:confirmed_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:confirmation_sent_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:unconfirmed_email).of_type(:string) }
    it { is_expected.to have_db_index(:email) }
    it { is_expected.to have_db_index(:reset_password_token) }
    it { is_expected.to have_db_index(:username) }

    it_behaves_like 'have timestamps'
  end
end
