class Office < ApplicationRecord
  validates :office_number, presence: true, uniqueness: true 
  validates :office_name, presence: true, length: { in: 2..30 }, uniqueness: true  
  
  # validate :name_only_once
  # validate :number_only_once
  
  # def name_only_once
  #   errors.add(:office_name, "は登録済です") if started_at.blank? && finished_at.present?
end
