############
# User specifies any number of arbitrary cutoffs in a parameter
#takes field_to_compare and spits into groups based on the parameter selection
view: custom_tiers {
  extension: required
  parameter: compare_cutoffs__arbitrary{
    #view_label: "Custom Tiers-{{_view._name}}"
    label: "Define Tiers using any number of comma separated breakpoints"
    description: "Define Tiers using any number of comma separated breakpoints"
    suggestions: ["0,10,100","-50,50,150,300"]
    default_value: "0,10,100"
    type:string
  }

  dimension: field_to_compare{
    hidden: yes
    sql:null;;
  }
  dimension: tier_number {
    hidden: yes
    type: number
    sql:
    {% assign my_array = compare_cutoffs__arbitrary._parameter_value | remove: "'" | split: "," %}
    {% assign last_group_max_label = '-∞' %}
    {% assign element_counter = 0 %}
    case
    {%for element in my_array%}
    {% assign element_counter = element_counter | plus: 1 %}
    when ${field_to_compare}<{{element}} then {{element_counter}}
    {% assign last_group_max_label = element %}
    {%endfor%}
    {% assign element_counter = element_counter | plus: 1 %}
    when ${field_to_compare}>={{last_group_max_label}} then {{element_counter}}
    else {{last_group_max_label | plus: 1 }}
    end
    ;;
    value_format_name: id
  }
  #the output field that will reflect the custom groups on field_to_compare
  dimension: compare_groups{
    label: "{{_view._name | replace: '_',' ' }} - Grouping"
    sql:
      {% assign my_array = compare_cutoffs__arbitrary._parameter_value | remove: "'" | split: "," %}
      {% assign last_group_max_label = '-∞' %}
      case
      {%for element in my_array%}
        when ${field_to_compare}<{{element}} then '{{last_group_max_label}}< & <{{element}}'
        {% assign last_group_max_label = element %}
      {%endfor%}
        when ${field_to_compare}>={{last_group_max_label}} then '>={{last_group_max_label}}'
      else 'unknown'
      end;;
    order_by_field: tier_number
    html: <span class="label label-info">{{tier_number._rendered_value}}</span> {{rendered_value}} ;;
  }


}
