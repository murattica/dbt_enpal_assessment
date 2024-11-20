
  create view "postgres"."test"."test_model__dbt_tmp"
    
    
  as (
    SELECT *
FROM "postgres"."public"."activity"
  );