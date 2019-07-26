connection: "thelook_events_redshift"
include: "*.view"

explore: users {
  #expose my extended versions of my feature, using a 'bare join'
  join: user_count__with_created_date_tooltip {sql:;; relationship:one_to_one}
  join: user_count__with_avg_age_tooltip {sql:;; relationship:one_to_one}
}


####################
###### Feature Template with placeholders for input and output fields.
view: tooltipify {
  measure: my_measure {
    hidden:yes
    type: number
  }
  measure: tooltip_for_my_measure {
    hidden:yes
  }
  measure: output_measure {
    sql: ${my_measure} ;;
    type: number
    html: {{my_measure._rendered_value}}<br><div align="center" style="width:100%; color:white; background:gray">({{tooltip_for_my_measure._rendered_value}})</div> ;;
  }
}


####################
##### Instantiate my feature, #1
view: user_count__with_created_date_tooltip {
  view_label: "Users"
  extends: [tooltipify]
  measure: my_measure {sql: ${users.count} ;;} ##must fully qualify input fields, and fields reference must be valid in the explore
  measure: tooltip_for_my_measure {sql: 'note: includes users created between ' || min(${users.created_date}) || ' and ' || max(${users.created_date}) ;;}
  measure: output_measure {label: "User Count with Created Date Tooltip"}
}


####################
##### Instantiate my feature, #2
view: user_count__with_avg_age_tooltip {
  view_label: "Users"
  extends: [tooltipify]
  measure: my_measure {sql: ${users.count} ;;}
  measure: tooltip_for_my_measure {sql: 'note: avg age ' || avg(${users.age}) ;;}
  measure: output_measure {label: "User Count with Avg Age Tooltip"}
}
