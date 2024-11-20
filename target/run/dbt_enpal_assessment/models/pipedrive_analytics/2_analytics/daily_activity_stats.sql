
      
        
            delete from "postgres"."pipedrive_analytics"."daily_activity_stats"
            where (
                date) in (
                select (date)
                from "daily_activity_stats__dbt_tmp220559904013"
            );

        
    

    insert into "postgres"."pipedrive_analytics"."daily_activity_stats" ("date", "kpi_name", "funnel_step", "deals_count")
    (
        select "date", "kpi_name", "funnel_step", "deals_count"
        from "daily_activity_stats__dbt_tmp220559904013"
    )
  