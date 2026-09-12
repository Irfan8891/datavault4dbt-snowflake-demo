import subprocess
from datetime import datetime
from pathlib import Path

from airflow import DAG
from airflow.operators.python import PythonOperator


DBT_PROJECT_DIR = Path(__file__).resolve().parents[1]
DBT_PROFILES_DIR = Path("/opt/airflow/config/.dbt")


def run_dbt(command: str) -> None:
    subprocess.run(
        [
            "dbt",
            command,
            "--project-dir",
            str(DBT_PROJECT_DIR),
            "--profiles-dir",
            str(DBT_PROFILES_DIR),
        ],
        check=True,
        cwd=DBT_PROJECT_DIR,
    )


with DAG(
    dag_id="datavault4dbt_snowflake_demo",
    start_date=datetime(2026, 1, 1),
    schedule="0 2 * * *",
    catchup=False,
    tags=["dbt", "snowflake"],
) as dag:

    dbt_deps = PythonOperator(
        task_id="dbt_deps",
        python_callable=run_dbt,
        op_args=["deps"],
    )

    dbt_build = PythonOperator(
        task_id="dbt_build",
        python_callable=run_dbt,
        op_args=["build"],
    )

    dbt_deps >> dbt_build