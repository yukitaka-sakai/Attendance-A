class User < ApplicationRecord
  has_many :attendances, dependent: :destroy
  #remember_tokenという仮想属性を作成
  attr_accessor :remember_token
  # 現在のメールアドレス(self.email)の値をdowncaseで小文字に変換
  before_save { self.email = email.downcase }

  validates :name,  presence: true, length: { maximum: 50 }
  
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 100 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: true    
  validates :basic_work_time, presence: true
  validates :designated_work_end_time, presence: true
  validates :designated_work_start_time, presence: true
  validates :affiliation, length: { in: 2..30 }, allow_blank: true #ブランクをスルー
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true # nilをスルー


  def self.import(file)
    num = 0
    CSV.foreach(file.path, headers: true,) do |row|
      # IDが見つかれば、レコードを呼び出し、見つかれなければ、新しく作成
      user = find_by(id: row["id"]) || new
      # CSVからデータを取得し、設定する
      user.attributes = row.to_hash.slice(*updatable_attributes)
      
      # 保存する
      user.save
      num += 1
    end
    num
  end

  # 更新を許可するカラムを定義
  def self.updatable_attributes
    ["id", "name", "email" ,"affiliation", "uid", "employee_number", "basic_work_time", "designated_work_start_time", "designated_work_end_time", "superior", "admin", "password"]
  end


  # 渡された文字列のハッシュ値を返す
  def User.digest(string)
    cost =
      if ActiveModel::SecurePassword.min_cost
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
  
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end
  
  # トークンがダイジェストと一致すればtrueを返す
  def authenticated?(remember_token)
    # ダイジェストが存在しない場合はfalseを返して終了します。
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end
  
  # ユーザーのログイン情報を破棄する
  def forget
    update_attribute(:remember_digest, nil)
  end
  
  def self.search(search) #ここでのself.はUser.を意味する
    if search
      where(['name LIKE ?', "%#{search}%"]) #検索とnameの部分一致を表示。User.は省略
    else
      all #全て表示。User.は省略
    end
  end
end

