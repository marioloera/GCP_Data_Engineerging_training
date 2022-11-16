CREATE OR REPLACE MODEL
  `prj-dev-hackwind-flt-01-90f1.wind_turbines_data_maureen_team.logistic_reg_model_01`
OPTIONS (
  model_type='logistic_reg', 
  labels = ['target']
) AS

SELECT * 
FROM `prj-dev-hackwind-flt-01-90f1.wind_turbines_data_maureen_team.pre_processed_train`
