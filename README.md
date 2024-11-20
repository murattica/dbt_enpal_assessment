### Pipedrive Analytics - Sales Funnel Case Study

## Overview

This project focuses on analyzing the sales funnel stages within a CRM system by aggregating daily counts across various stages of the sales process. The funnel includes steps like Lead Generation, Needs Assessment, Proposal Preparation, Closing, and more. The final reporting model, monthly_stats, aggregates data from the intermediate models monthly_activity_stats and monthly_deal_stats, providing a comprehensive view of monthly performance across activities and deals.

The project is structured around creating and managing data models in dbt, specifically designed to process Pipedrive CRM data into actionable insights that can track and improve sales funnel efficiency.

Sales Funnel Stages

Below are the stages modeled in this project:

- Lead Generation
- Qualified Lead
- Sales Call 1
- Needs Assessment
- Sales Call 2
- Proposal/Quote Preparation
- Negotiation
- Closing
- Implementation/Onboarding
- Follow-up/Customer Success
- Renewal/Expansion

## Data Modeling Flow

![image](https://github.com/user-attachments/assets/8abf235b-f2ca-4b8f-af93-7e53d0cd3f1a)

**Daily Aggregations:** Data is first aggregated at a daily level in daily_activity_stats and daily_deal_stats models. This daily data is further rolled up to provide monthly insights.

**Monthly Aggregations:** monthly_activity_stats and monthly_deal_stats use daily aggregate tables to compute monthly metrics, ultimately feeding into the final monthly_stats reporting model.

**Design Choice:** Daily-level aggregation was chosen first to provide granular insights and a modular approach that allows for easy scaling and recalculation of monthly metrics if any changes occur in daily metrics.

## Project Features

1. Backfilling Support

The project is designed to support backfilling by utilizing an incremental model structure and allowing flexible reference dates through variable configurations. Below is an example of the incremental configuration used:

```
{{
    config(
        materialized='incremental',
        incremental_strategy='delete+insert',
        unique_key='date',
        alias='daily_activity_stats',
        on_schema_change='append_new_columns',
        full_refresh=false
    )
}}

{% set source = source_dt(var('source_dt')) %}

select
    due_date as date,
    kpi_name,
    funnel_step,
    count(distinct case when done = true then deal_id end) as deals_count
from {{ ref('activity_staging') }}
where 1=1
    {% if is_incremental() %}
    and due_date >= '{{ source }}'::date - {{ var('backfill_period') }}
    and due_date <= '{{ source }}'::date
    {% else %}
    and due_date > date_trunc('month', current_date) - interval '{{ var('months') }} month'  
    {% endif %}
group by
    date,
    kpi_name,
    funnel_step
```

**Reference Date (Source Date) System:**

A source_dt variable is used to control the reference date for processing data.

The reference date is defined by the ref_date macro and defaults to the run date (today). If source_dt is provided as an input parameter in the dbt run, it will be used instead of today. This design makes it easy to govern backfilling or re-processing windows dynamically using the backfill_period variable.

2. Incremental Run Configuration

The incremental nature of the models is handled through model-level configurations, allowing both incremental runs and full refreshes. The configuration includes options like incremental_strategy as 'delete+insert', and a full_refresh flag to control when a complete data refresh is required. This setup helps manage the data processing efficiently without unnecessary reprocessing.

The daily_activity_stats table uses the following filter logic to differentiate between full refresh and incremental runs:

Full Refresh: Includes all data based on historical range.

Incremental Run: Filters data to only the incremental window, specified by the backfill_period.

3. Environment-Specific Profiles

I set up dev and production profiles in dbt. The development profile creates models under a different test schema, whereas the production profile uses the production environment schema. To ensure that custom schema names work as expected, I used get_custom_schema and get_custom_database macros. This approach allows for a clear separation between testing and production environments, ensuring data consistency and reducing the risk of accidental data overwrites in production.

4. Documentation

Documentation was added for each model, using .md files for dbt docs. This ensures each model, field, and transformation step is clearly described, which helps the data engineering team and stakeholders understand the data lineage and business context.

5. Testing

I defined generic dbt tests, such as not_null on deal_id, as a demo. Additional tests could include Accepted Values Tests, custom tests like Running Sum Comparison, and Ratio Tests to check that at least 50% of deals that reach Proposal/Quote Preparation progress to Negotiation.

Further, the Great Expectations package could be beneficial for more complex validations. One example of a Great Expectations-specific feature is the ability to validate data types across different columns to ensure that the data structure matches the expected schema, which is particularly useful for maintaining consistent data quality. I added this package under packages.yml but haven't demonstrated any of its feature.

I also implemented a source freshness check for the activity table to ensure that the data is refreshed within a specified timeframe. This helps maintain data reliability by verifying that the source data remains up-to-date for downstream transformations.

