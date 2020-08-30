require 'csv'

CSV.generate do |csv|
  column_names = %w(日付 曜日 出社時間 退社時間 在社時間)
  # 1行目に表示する項目を設定
  csv << column_names
  
  
  @attendances.each do |day|
    column_values = [
      l(day.worked_on, format: :short),
      $days_of_the_week[day.worked_on.wday],
      (day.started_at.floor_to(15.minutes).strf("%H:%M") if day.started_at.present?),
      (day.finished_at.floor_to(15.minutes).strf("%H:%M") if day.finished_at.present?),
      format("%.2f", (str_times = working_times(day.started_at, day.finished_at)))
    ]
    # 2行目に表示する項目を設定
    csv << column_values
  end
end


