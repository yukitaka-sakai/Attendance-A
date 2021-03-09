class Office < ApplicationRecord
  has_many :users, dependent: :destroy
  
  validates :office_name, presence: true, length: { in: 2..30 }, uniqueness: true  
  
  enum office_type: { 出勤: "出勤", 退勤: "退勤" }
  # validate :name_only_once
  # validate :number_only_once
  
  # def name_only_once
  #   errors.add(:office_name, "は登録済です") if started_at.blank? && finished_at.present?
end
