class StorySerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :body, :attachment, :type


  def attachment
    url_for(object.attachment)
  end

  def type
    object.attachment.content_type
  end

end
