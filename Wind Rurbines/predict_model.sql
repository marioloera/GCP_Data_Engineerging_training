SELECT *
FROM ml.PREDICT (
    MODEL `prj-dev-hackwind-flt-01-90f1.wind_turbines_data_maureen_team.logistic_reg_model_01`,
    (
      SELECT * EXCEPT(target)
      FROM
        `prj-dev-hackwind-flt-01-90f1.wind_turbines_data_maureen_team.pre_processed_test`      
    )
  )
