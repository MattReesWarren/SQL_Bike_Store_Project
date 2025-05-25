Bike Store SQL Data Project

This repository contains a full end-to-end SQL pipeline for building a relational data model for a bike store, moving data through three main stages: Raw, Clean, and Final (Analytical Model). Each stage is represented by both SQL scripts and example CSV data files.

Project Structure
	•	Schemas/
SQL scripts for creating the three main schemas:
	◦	Load_Schema(Raw).sql – Creates the raw data schema for initial data load.
	◦	Load_Schema(Clean).sql – Defines the clean, typed, and normalized staging schema.
	◦	Load_Schema(Final).sql – Builds the analytics-ready data warehouse model.
	•	Queries/
	◦	Clean/ – Scripts for data profiling, cleaning, type standardization, normalization, and cleaning loops.
	◦	Final/ – Scripts for final transformations and data validation before loading into the warehouse.
	◦	Aggregation/ – Analytic/summary queries (e.g. overview, staff, product, geo, customer, and time-series aggregations).
	•	Views/
SQL scripts to create views for common analytical queries.
	•	Files/
	◦	Raw/ – Example source CSVs for the raw stage (as originally received).
	◦	Final/ – Processed CSVs as a backup for loading directly into the Final schema, if needed.
	•	Model/
MySQL Workbench data model (FinalBK_MASTER.mwb).
	•	Report/
Project documentation and detailed notes (SQL Process Notes (STAGE 1).docx).

Data Pipeline & Run Order
Stage 1: Raw
	1	Create the Raw schema with Schemas/Load_Schema(Raw).sql.
	2	Load the raw CSV files from Files/Raw/ into the corresponding Raw tables.
	◦	Data is loaded as-is, with minimal to no type enforcement or cleaning.
Stage 2: Clean
	1	Create the Clean schema with Schemas/Load_Schema(Clean).sql.
	2	Run cleaning scripts in Queries/Clean/, in this order:
	◦	Profiling
	◦	Null loop
	◦	Standardisation
	◦	Datatype
	◦	Normalisation
	3	Load processed CSV files from Files/Clean/ into the Clean schema tables.
Stage 3: Final
	1	Create the Final schema with Schemas/Load_Schema(Final).sql.
	2	Run final scripts in Queries/Final/, in this order:
	◦	Transformations
	◦	Validation
Stage 4: Aggregation
	•	Run queries in Queries/Aggregation/ and the pre-built views in Views/ for reporting and analytics.

Notes
	•	Each stage is designed to be independent; do not skip steps.
	•	For full details of the workflow and rationale behind each step, see Report/SQL Process Notes (STAGE 1).docx.
	•	The pipeline assumes MySQL but can be adapted to other RDBMS with minor modifications.

Quick Start
	1	Run schema scripts in order: Raw → Clean → Final.
	2	Load corresponding CSV files at each stage.
	3	Use cleaning and transformation queries as described.
	4	Use analytics scripts and views for reporting.

For more context, refer to the documentation in the Report/ folder.

*All data in this repository is for demonstration and educational purposes only; included data does not represent real customer or business information*

Author Matt Rees-Warren
