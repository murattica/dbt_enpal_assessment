select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
    



select activity_id
from "postgres"."public"."activity"
where activity_id is null



      
    ) dbt_internal_test