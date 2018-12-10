DROP TABLE IF EXISTS titanic_model;
DROP TABLE IF EXISTS titanic_model_summary;
DROP TABLE IF EXISTS titanic_predict;

SELECT madlib.tree_train(
  'titanic_train',
  'titanic_model',
  'passengerid',
  'survived',
  'pclass,sex,age,fare',
  null,
  'gini'
);

SELECT madlib.tree_predict(
  'titanic_model',
  'titanic_test',
  'titanic_predict',
  'response'
);

\copy titanic_predict to 'titanic_predict.csv' with (format csv, header true);

DROP TABLE IF EXISTS titanic_model_2;
DROP TABLE IF EXISTS titanic_model_2_summary;
DROP TABLE IF EXISTS titanic_predict_2;

SELECT madlib.tree_train(
  'titanic_train',
  'titanic_model_2',
  'passengerid',
  'survived',
  'pclass,sex,age,fare,sibsp,parch,embarked',
  null,
  'gini',
  null,
  null,
  5
);

SELECT madlib.tree_predict(
  'titanic_model_2',
  'titanic_test',
  'titanic_predict_2',
  'response'
);

\copy titanic_predict_2 to 'titanic_predict_2.csv' with (format csv, header true);
