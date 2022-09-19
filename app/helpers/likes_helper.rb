module LikesHelper
  def like_date(likeable)
    like = likeable.user.likes.find_by(likeable: likeable)
    like&.updated_at&.strftime("%B #{like.updated_at.day.ordinalize}, %Y")
  end
end
