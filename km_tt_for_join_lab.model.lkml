connection: "thelook_events_redshift"
include: "*.view"


##### We can add our feature to any existing explore.  In this example we'll use a simple explore based on a Users view
explore: users {
  # Use Joins to expose my instantiated versions of my feature (see instantiation below).
  # - We'll use a special technique we call a 'bare join', because this 'join' doesn't actually require any additional joins in the generated sql
  join: user_count__with_created_date_tooltip {
    sql:/*note for generated sql: bare join for user_count__with_created_date_tooltip*/;; #using a bare join: generated sql's from clause will not include any additional sql for the purpose of this join
    relationship:one_to_one #relationship parameter required even for a bare join.  Use one_to_one to tell looker it doesn't need to worry about any double counting possibility
    view_label:"Users" #put this joins field(s) under an existing view label, for a clean field picker
  }
  join: user_count__with_avg_age_tooltip {
    sql:/*note for generated sql: bare join for user_count__with_avg_age_tooltip*/;;
    relationship:one_to_one
    view_label:"Users"
  }
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
    # In this example, this html parameter has the logic we want to apply repeatably.  Because of this approach, we'll be able to manage this feature's code in ONE place
    html: {{my_measure._rendered_value}}<br><div align="center" style="width:100%; color:white; background:gray; font-size:10px">*{{tooltip_for_my_measure._rendered_value}}</div> ;;
  }
}


####################
##### Instantiate my feature, #1
view: user_count__with_created_date_tooltip {
  extends: [tooltipify]
  measure: my_measure {sql: ${users.count} ;;} ##must fully qualify input fields, and fields reference must be valid in the explore
  measure: tooltip_for_my_measure {sql: 'Users created between ' || min(${users.created_date}) || ' and ' || max(${users.created_date}) ;;}
  measure: output_measure {label: "User Count with Created Date Tooltip"}
}


####################
##### Instantiate my feature, #2
view: user_count__with_avg_age_tooltip {
  extends: [tooltipify]
  measure: my_measure {sql: ${users.count} ;;}
  measure: tooltip_for_my_measure {sql: 'Average Age: ' || avg(${users.age}) ;;}
  measure: output_measure {label: "User Count with Avg Age Tooltip"}
}
