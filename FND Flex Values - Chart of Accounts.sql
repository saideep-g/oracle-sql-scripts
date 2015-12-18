ALTER SESSION SET NLS_LANGUAGE='AMERICAN';

SELECT DECODE(flex_value_set_id,1014969, 'ACTIVITY' ,1014967, 
              'ENTITY' ,1014974, 'FUTURE' ,1014971, 'INTERCOMPANY' ,1014973, 
              'LINE_OF_BUSINESS' ,1014968, 'LOCATION' ,1014970, 'NATURAL_ACCOUNT' ,1014972, 
              'PRODUCT' ,'ERROR') segment_type ,
  flex_value_meaning ,
  description ,
  creation_date ,
  last_update_date ,
  enabled_flag ,
  parent_flex_value_low ,
  PARENT_FLEX_VALUE_HIGH ,
  Summary_flag "PARENT" ,
  SUBSTR(compiled_value_attributes,1,1) allow_budgeting ,
  SUBSTR(COMPILED_VALUE_ATTRIBUTES,3,1) ALLOW_POSTING ,
  SUBSTR(COMPILED_VALUE_ATTRIBUTES,5,1) ACCOUNT_TYPE
FROM apps.fnd_flex_values_VL ffv
WHERE FLEX_VALUE_SET_ID    IN (1014969,1014967,1014974,1014971,1014973,1014968,1014970,1014972)
AND last_update_date     > sysdate -14 -- this value can be changed based on need; 7 represents days
ORDER BY flex_value_set_id ;


--Parent & Child relationship
SELECT          fset.flex_value_set_name "Value Set",
                         fvalue.flex_value_set_id "Value Set Id",
                         fvalue.flex_value "Child Value",
                         fvalue.parent_flex_value "Parent Value"
FROM             FND_FLEX_VALUE_SETS                  fset,
                         FND_FLEX_VALUE_CHILDREN_V  fvalue
WHERE          (fvalue.flex_value, fvalue.flex_value_set_id) in (
                         select flex_value, flex_value_set_id
                         from FND_FLEX_VALUE_CHILDREN_V
                         group by flex_value, flex_value_set_id
                         having count(1) > 1)
AND               fset.flex_value_set_id = fvalue.flex_value_set_id
ORDER BY    fvalue.flex_value_set_id, fvalue.flex_value, fvalue.parent_flex_value;

---CoA details along with French Translations----
SELECT DECODE(flex_value_set_id,1014969, 'ACTIVITY' ,1014967, 
              'ENTITY' ,1014974, 'FUTURE' ,1014971, 'INTERCOMPANY' ,1014973, 
              'LINE_OF_BUSINESS' ,1014968, 'LOCATION' ,1014970, 'NATURAL_ACCOUNT' ,1014972, 
              'PRODUCT' ,'ERROR') segment_type ,
  ffv.flex_value_meaning ,
  ffv.description ,
  ffvt.description French_desc,
  ffv.creation_date ,
  ffv.last_update_date ,
  enabled_flag ,
  parent_flex_value_low ,
  PARENT_FLEX_VALUE_HIGH ,
  Summary_flag "PARENT" ,
  SUBSTR(compiled_value_attributes,1,1) allow_budgeting ,
  SUBSTR(COMPILED_VALUE_ATTRIBUTES,3,1) ALLOW_POSTING ,
  SUBSTR(COMPILED_VALUE_ATTRIBUTES,5,1) ACCOUNT_TYPE
FROM apps.fnd_flex_values_VL ffv, apps.fnd_flex_values_tl ffvt
WHERE FLEX_VALUE_SET_ID           IN (1014969,1014967,1014974,1014971,1014973,1014968,1014970,1014972)
--AND ffv.last_update_date     > sysdate -14 -- You can change this date condition as per need. 7 represents days
and ffv.flex_value_id = ffvt.flex_value_id
and ffvt.language ='FRC' --French
ORDER BY flex_value_set_id ;
