{{ config(materialized='view') }}

{%- set yaml_metadata -%}
source_model:
    'STAGE': 'Supplier'
hashed_columns: 
    hk_supplier_h:
        - s_suppkey
    hk_nation_h:
        - s_nationkey
    hk_supplier_nation_l:
        - s_suppkey
        - s_nationkey
    hd_supplier_p_s:
        is_hashdiff: true
        columns:
            - s_name
            - s_address
            - s_phone
    hd_supplier_n_s:
        is_hashdiff: true
        columns:
            - s_acctbal
            - s_comment
ldts: "SYSDATE()"
rsrc: '!STAGE.Supplier'
{%- endset -%}

{{ datavault4dbt.stage(yaml_metadata=yaml_metadata) }}