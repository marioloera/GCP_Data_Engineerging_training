SELECT
  *,
  CASE
    WHEN roc_auc > .9 THEN 'good'
    WHEN roc_auc > .8 THEN 'fair'
    WHEN roc_auc > .7 THEN 'decent'
    WHEN roc_auc > .6 THEN 'not great'
    ELSE 'poor'
    END AS model_quality
FROM
  ML.EVALUATE(
    MODEL `prj-dev-hackwind-flt-01-90f1.wind_turbines_data_maureen_team.logistic_reg_model_01`,
    (
      SELECT *
      FROM
        `prj-dev-hackwind-flt-01-90f1.wind_turbines_data_maureen_team.pre_processed_test`      
    )
  )