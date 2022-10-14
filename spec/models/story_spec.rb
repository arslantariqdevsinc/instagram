require 'rails_helper'

RSpec.describe Story, type: :model do
  context 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_one_attached(:attachment) }
  end

  context 'validations' do
    it { is_expected.to validate_presence_of(:body) }
    it { is_expected.to validate_length_of(:body).is_at_most(2200) }
    it { is_expected.to validate_presence_of(:attachment) }
  end

  context 'column specifications' do
    it { is_expected.to have_db_column(:body).of_type(:string).with_options(limit: 2200, null: false) }
    it { is_expected.to have_db_column(:user_id).of_type(:integer).with_options(null: false) }
    it { is_expected.to have_db_index(:user_id) }
    it_behaves_like 'have timestamps'
  end

  context 'callbacks' do
    let(:user) { create :user }
    include ActiveJob::TestHelper
    after do
      clear_enqueued_jobs
    end

    context 'when valid story' do
      it 'should enqueue a Story cleanup job' do
        story = create :story, user: user

        expect(StoriesCleanupJob)
          .to have_been_enqueued
          .with(story.id)
      end
    end

    context 'when invalid story' do
      let(:invalid_story_id) { Story.exists? ? Story.maximum(:id) + 1 : 1 }

      it 'should enqueue a Story cleanup job' do
        StoriesCleanupJob.set(wait: 24.hours).perform_later(invalid_story_id)

        expect(StoriesCleanupJob)
          .to have_been_enqueued
          .with(invalid_story_id)
      end
    end
  end
end
