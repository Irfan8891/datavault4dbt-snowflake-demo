{{ config(materialized='view') }}

{%- set yaml_metadata -%}
source_model:
    'STAGE': 'Nation'
hashed_columns: 
    hk_nation_h:
        - n_nationkey
    hk_region_h:
        - n_regionkey
    hk_nation_region_l:
        - n_nationkey
        - n_regionkey
    hd_nation_n_s:
        is_hashdiff: true
        columns: 
            - n_name
            - n_comment
ldts: "SYSDATE()"
rsrc: '!STAGE.Nation'
{%- endset -%}

{{ datavault4dbt.stage(yaml_metadata=yaml_metadata) }}