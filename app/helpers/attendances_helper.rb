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
end 
