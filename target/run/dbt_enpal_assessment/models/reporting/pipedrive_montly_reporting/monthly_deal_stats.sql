
      
        
            delete from "postgres"."reports"."monthly_deal_stats"
            where (
                month) in (
                select (month)
                from "monthly_deal_stats__dbt_tmp220600039549"
            );

        
    

    insert into "postgres"."reports"."monthly_deal_stats" ("month", "field", "kpi_name", "funnel_step", "deals_count")
    (
        select "month", "field", "kpi_name", "funnel_step", "deals_count"
        from "monthly_deal_stats__dbt_tmp220600039549"
    )
  