module ApplicationHelper
  def user_avatar(user, size = 40)
    if user.avatar.attached?
      user.avatar.variant(resize: "#{size}x#{size}!")
    else
      gravatar_image_url('spam@spam.com'.gsub('spam', 'mdeering'), size: size)
    end
  end

  def date(record)
    record.created_at.strftime('%B %d, %Y')
  end
end
