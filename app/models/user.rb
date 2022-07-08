# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :validatable

  has_many :articles, dependent: :destroy
  has_many :likes, dependent: :destroy

  # usersテーブル -> likesテーブル -> articlesテーブル
  # favorite_articlesのDBもモデルも存在しない -> ソースのarticleを参照
  has_many :favorite_articles, through: :likes, source: :article

  has_many :following_relationships, foreign_key: "follower_id", class_name: "Relationship", dependent: :destroy
  has_many :followings, through: :following_relationships, source: :following

  has_many :follower_relationships, foreign_key: "following_id", class_name: "Relationship", dependent: :destroy
  has_many :followers, through: :follower_relationships, source: :follower

  has_one :profile, dependent: :destroy

  delegate :birthday, :age, :gender, to: :profile, allow_nil: true

  # def birthday
  #   profile&.birthday
  # end

  # def gender
  #   profile&.gender
  # end

  def has_written?(article)
    articles.exists?(id: article)
  end

  def has_liked?(article)
    likes.exists?(article_id: article.id)
  end

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

  def follow!(user)
    following_relationships.create!(following_id: user.id)
  end

  def unfollow!(user)
    relation = following_relationships.find_by!(following_id: user.id)
    relation.destroy!
  end

  def prepare_profile
    profile || build_profile
  end

  def avatar_image
    if profile&.avatar&.attached?
      profile.avatar
    else
      'default-avatar.png'
    end
  end

end
