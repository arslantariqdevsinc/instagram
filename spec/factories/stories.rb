FactoryBot.define do
  factory :story do
    body { 'test story' }
    user

    after(:build) do |story|
      story.attachment.attach(
        io: File.open(Rails.root.join('app/assets', 'images', 'instagram.png')),
        filename: 'instagram.png',
        content_type: 'image/png'
      )
    end
  end
end
