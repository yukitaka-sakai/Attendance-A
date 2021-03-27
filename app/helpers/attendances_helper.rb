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
  def overtimes_1(overtimefinish, overtime_next_day)
    if overtime_next_day == "1"
      format("%.2f", ((overtimefinish.hour - @user.designated_work_end_time.hour) + ((overtimefinish.min - @user.designated_work_end_time.min) / 60.0) + 24))
    else
      format("%.2f", ((overtimefinish.hour - @user.designated_work_end_time.hour) + ((overtimefinish.min - @user.designated_work_end_time.min) / 60.0)))
    end
  end
  
  # def overtimes_2(day_start, day_finish, next_day)
  #   @overtime_judge = format("%.2f",((@user.basic_work_time.hour + (@user.basic_work_time.min)/60.0))) #@overtime_judge 基本勤務時間
  #   if day_finish.present? && @overtime_judge.to_f < @str_times.to_f
  #     if next_day == "1"
  #       (@str_times.to_f + 24) - @overtime_judge.to_f
  #     else
  #       @str_times.to_f - @overtime_judge.to_f
  #     end
  #   else
  #     @str_times.to_f - @overtime_judge.to_f
  #   end
  # end
  
  def overtimes_3(day_start, overtime_finish, next_day)
    @overtime_judge = format("%.2f",((@user.basic_work_time.hour + (@user.basic_work_time.min)/60.0)))
    @start_present_overtime_judge = format("%.2f",((day_start.hour + (day_start.min)/60.0)))
    @scheduled_to_end = format("%.2f",((overtime_finish.hour + (overtime_finish.min)/60.0)))
    if day_start.present?
      if next_day == "1"
        (@scheduled_to_end.to_f + 24 ) - @start_present_overtime_judge.to_f - @overtime_judge.to_f
      else
        @scheduled_to_end.to_f - @start_present_overtime_judge.to_f - @overtime_judge.to_f
      end
    end
  end
  
  def overtimes_4(overtime_finish, next_day)
    @design_work_end = format("%.2f",((@user.designated_work_end_time.hour + (@user.designated_work_end_time.min)/60.0))) 
    @scheduled_to_end = format("%.2f",((overtime_finish.hour + (overtime_finish.min)/60.0)))
    if overtime_finish.present?
      if next_day == "1"
        (@scheduled_to_end.to_f + 24 ) - @design_work_end.to_f
      else
        @scheduled_to_end.to_f - @design_work_end.to_f
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
