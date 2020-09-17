class Attendance < ApplicationRecord
  belongs_to :user
  
  validates   :worked_on, presence: true
  validates   :note, length: { maximum: 50 }
  
  
  # 出社時間がない場合、退勤時間は無効
  validate :finished_at_is_invalid_without_a_started_at
  # 出社。退社時間どちらも存在する場合、出社時間より早い退社時間は無効
  validate :started_at_than_finished_at_fast_if_invalid
  # validate :empty_notes_when_editing
  
  def finished_at_is_invalid_without_a_started_at
    errors.add(:started_at, "が必要です") if started_at.blank? && finished_at.present?
  end
  
  def started_at_than_finished_at_fast_if_invalid
    if (started_at.present? && finished_at.present?) && next_day == "0" # 且つnext_dayが"0"の場合
      errors.add(:started_at, "より早い退勤時間は無効です") if started_at > finished_at
    end
  end
  
  # def empty_notes_when_editing
  #   errors.add(:started_at, "が必要です")
  #   if (started_at.present? && finished_at.present?) && will_save_change_to_start_time?
  #   end
  # end
end