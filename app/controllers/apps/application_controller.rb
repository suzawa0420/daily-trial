class Apps::ApplicationController < ApplicationController
  before_action :authenticate_user!

  # Apps => ログインしていユーザーのみに適用するためのフォルダ分け

end