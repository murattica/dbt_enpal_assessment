
      
        
            delete from "postgres"."pipedrive_analytics"."daily_deal_stats"
            where (
                date) in (
                select (date)
                from "daily_deal_stats__dbt_tmp220559969647"
            );

        
    

    insert into "postgres"."pipedrive_analytics"."daily_deal_stats" ("date", "field", "kpi_name", "funnel_step", "deals_count")
    (
        select "date", "field", "kpi_name", "funnel_step", "deals_count"
        from "daily_deal_stats__dbt_tmp220559969647"
    )
  