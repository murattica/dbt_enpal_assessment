
      
        
            delete from "postgres"."reports"."monthly_activity_stats"
            where (
                month) in (
                select (month)
                from "monthly_activity_stats__dbt_tmp220600003980"
            );

        
    

    insert into "postgres"."reports"."monthly_activity_stats" ("month", "kpi_name", "funnel_step", "deals_count")
    (
        select "month", "kpi_name", "funnel_step", "deals_count"
        from "monthly_activity_stats__dbt_tmp220600003980"
    )
  