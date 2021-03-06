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
      format("%.2f", (((finish - start) / 60) / 60.0) + 24)
    else
      format("%.2f", (((finish - start) / 60) / 60.0))
    end
  end
  
  # メソッド 名（1,2,3)の順番で引数を呼び出す。引数はカラム名は使わない。
  def overtimes_1(overtimefinish, designated_work_end_time, overtime_next_day)
    # debugger
    if overtime_next_day == "1"
      format("%.2f", ((overtimefinish.hour - designated_work_end_time.hour) + ((overtimefinish.min - designated_work_end_time.min) / 60.0) + 24))
    else
      format("%.2f", ((overtimefinish.hour - designated_work_end_time.hour) + ((overtimefinish.min - designated_work_end_time.min) / 60.0)))
    end
  end
  
  def overtimes_2(day_finish, designated_work_end_time, edit_next_day)
    # debugger
    if format("%.2f", (day_finish.min - @user.designated_work_end_time.min)) <= 0.to_s
      if edit_next_day == "1"
        format("%.2f", ((day_finish.hour - designated_work_end_time.hour) + ((day_finish.min - designated_work_end_time.min) / 60.0) + 24))
      else
        format("%.2f", ((day_finish.hour - designated_work_end_time.hour) + ((day_finish.min - designated_work_end_time.min) / 60.0)))
      end
    end
  end
  
  def overtimes_3(day_start, day_finish, designated_work_end_time, next_day)
    # debugger
    @overtime_judge = format("%.2f",((@user.basic_work_time.hour + (@user.basic_work_time.min)/60.0))) 
    if day_finish.present? && @overtime_judge.to_f < @total_working_times
      if next_day == "1"
        (@str_times.to_f + 24) - @overtime_judge.to_f
      else
        # debugger
        @str_times.to_f - @overtime_judge.to_f
      end
    end
  end

  def format_hour(time) #時間表示の「時間部分」を２桁（００）で表示する。
    format("%02d", time.hour)
  end
  
  def format_min(time) #時間表示び「分部分」を２桁（００）で表示する。
    format("%02d", ((time.min / 15) * 15)) #time.minを15で割り、%02bで自動的に小数点は消え、15を掛け戻すことで15分で丸まる
  end
end
