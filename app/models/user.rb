class User < ApplicationRecord
  #remember_tokenという仮想属性を作成
  attr_accessor :remember_token
  # 現在のメールアドレス(self.email)の値をdowncaseで小文字に変換
  before_save { self.email = email.downcase }

  validates :name,  presence: true, length: { maximum: 50 }
  
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 100 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: true    
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }


  # 渡された文字列のハッシュ値を返す
  def User.digest(string)
    cost =
      if ActiveModel::ScurePassword.min_cost
        BCrypt::Engine::MIN_COST
      else
        BCrypt::Engine.cost
      end
    BCrypt::Password.create(string, cost: cost)
  end
  
  # ランダムなトークンを返す.Rubyの標準ライブラリSecureRandomモジュールにあるurlsafe_base64
  def User.new_token
    SecureRandom.urlsafe_base64
  end
  
  def remember_token
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end
  
  # トークンがダイジェストと一致すればtrueを返す
  def authenticated?(remember_token)
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end
end

