class StoriesCleanupJob < ApplicationJob
  queue_as :default

  def perform(story_id)
    story = Story.find(story_id)
    story.destroy
  rescue ActiveRecord::RecordNotFound
  end
end
