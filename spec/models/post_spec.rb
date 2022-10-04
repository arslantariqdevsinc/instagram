require 'rails_helper'

RSpec.describe Post, type: :model do

  let(:user) { create :user }
  subject { build :post, user: user}

  #{Four phased testing}

  context 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:comments).dependent(:destroy) }
    it { is_expected.to have_many(:likes).dependent(:destroy) }
    it { is_expected.to have_many_attached(:images) }
  end

  context 'validations' do
    it { is_expected.to validate_presence_of(:body) }
    it { is_expected.to validate_length_of(:body).is_at_most(2200) }
    it { is_expected.to validate_presence_of(:images) }
  end

  context 'column specifications' do

    it { is_expected.to have_db_column(:body).of_type(:string).with_options(limit: 2200, null: false)}

    it { is_expected.to have_db_column(:user_id).of_type(:integer).with_options(null: false) }

    it { is_expected.to have_db_column(:created_at).of_type(:datetime).with_options(precision: 6, null: false) }

    it { is_expected.to have_db_column(:updated_at).of_type(:datetime).with_options(precision: 6, null: false) }

    it { is_expected.to have_db_index(:user_id)}

  end

  context 'behaviour' do
    it 'atmost 10 images are allowed' do

      11.times do
        subject.images.attach(
          io: File.open(Rails.root.join('app/assets', 'images', 'instagram.png')),
          filename: 'instagram.png',
          content_type: 'image/png'
        )
      end

      expect(subject).to_not be_valid
    end
  end

  # context 'before publication' do
  #   it 'cannot have comments' do
  #     expect { Post.create.comments.create! }.to raise_error(ActiveRecord::RecordNotSaved)
  #   end

  #   it 'cannot have likes' do
  #     expect { Post.create.likes.create! }.to raise_error(ActiveRecord::RecordNotSaved)
  #   end
  # end
end
