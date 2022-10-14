class TurboModalComponent < ViewComponent::Base
  include Turbo::FramesHelper
  def initialize(title:)
    super
    @title = title
  end
end
