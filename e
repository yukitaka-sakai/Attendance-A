
[1mFrom:[0m /home/ec2-user/environment/attendance_A_app/app/views/attendances/edit_one_month.html.erb:47 ActionView::CompiledTemplates#_app_views_attendances_edit_one_month_html_erb___2399712015163592080_69882960396340:

    [1;34m42[0m:                 <td><%= attendance.time_field :started_at, class: "form-control" %></td>
    [1;34m43[0m:                 <td><%= attendance.time_field :finished_at, class: "form-control" %></td> 
    [1;34m44[0m:                 <td><%= attendance.check_box :next_day %></td>
    [1;34m45[0m:                 <td></td>
    [1;34m46[0m:                 <td><%= attendance.text_field :note, placeholder: "入力必須", class: "form-control" %></td>
 => [1;34m47[0m:                 <td><%= attendance.collection_select :application_superior, @superiors, :id, :name, {include_blank: true, selected: nil}, class: "form-control" %></td>
    [1;34m48[0m:               <% end %>
    [1;34m49[0m:             </tr>
    [1;34m50[0m:           <% end %>
    [1;34m51[0m:         <% end %>
    [1;34m52[0m:       </tbody>

