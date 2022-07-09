# frozen_string_literal: true

module UserDecorator
  def display_name
    # ぼっち演算子
    profile&.nickname || self.email.split('@').first

    # if profile && profile.nickname
    #   profile.nickname
    # else
    #   self.email.split('@').first
    #   # cohki0335@gmail.com
    #   # => ['cohki0305', 'gmail.com']
    # end
  end

  def avatar_image
    if profile&.avatar&.attached?
      profile.avatar
    else
      'default-avatar.png'
    end
  end


end
