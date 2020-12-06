module AttendancesHelper
  
  def attendance_state(attendance) #ボタンのコードを一つにしてボタンに表示されるテキストの条件を決める。
    # 受けとったAttendanceオブジェクトが当日と一致するか評価する
    if Date.current == attendance.worked_on
      return "出勤" if attendance.started_at.nil?
      return "退勤" if attendance.started_at.present? && attendance.finished_at.nil?
    end
    # どれにも当てはまらない場合falseをかえす
    false
  end
  
  # 出社時間と退社時間を受け取り、在社時間を計算して返す。

  def working_times(start, finish, next_day)
    if next_day == "1"
      format("%.2f", (((finish - start) / 60) / 60.0)+ 24)
    else
      format("%.2f", (((finish - start) / 60) / 60.0))
    end
  end
  
  def overtimes(overtime_finished_at, designated_work_end_time, overtime_next_day)
    if overtime_next_day == "1"
      format("%.2f", (((overtime_finished_at - designated_work_end_time) / 60) / 60.0))
    else
      format("%.2f", (((overtime_finished_at - designated_work_end_time) / 60) / 60.0))
    end
  end
end 
