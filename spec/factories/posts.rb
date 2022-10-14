FactoryBot.define do
  factory :post do
    body { 'test post' }
    user

    after(:build) do |post|
      post.images.attach(
        io: File.open(Rails.root.join('app/assets', 'images', 'instagram.png')),
        filename: 'instagram.png',
        content_type: 'image/png'
      )
    end
  end
end
