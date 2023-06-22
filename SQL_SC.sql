/*If the senior citizen has a desire and he feels himself physically and mentally healthy, then by involving him in any program or initiative run by any organization or government, bank, he based on his qualification and experience can help him handle his present issues and also future plans. It will benefit the senior citizen as well as the government or institution. वरिष्ठ नागरिक की यदि ईच्छा हैं और वह अपने आप को शारीरिक मानसिक रूप से स्वास्थ्य महसूस करता हैं तो उन्हें किसी संस्था या सरकार , बैंक द्वारा चलाए जा रहे कार्यक्रम या उपक्रम में शामिल कर उन्हें उनकी योग्यता, अनुभव, कहानी, किस्से तथा भविष्य की योजना एवं आने वाली समस्या से निपटा जा सकता हैं जिससे वरिष्ठ नागरिक को भी लाभ होगा और सरकार या संस्था को भी।*/

drop table if exists SeniorCitizen;
CREATE TABLE SeniorCitizen (
  id INT PRIMARY KEY,
  name VARCHAR(255),
  age INT,
 
);

BULK INSERT SeniorCitizen
FROM 'E:\SeniorCitizen0.csv'
WITH (
  FORMAT = 'CSV',
  FIELDTERMINATOR = ',',
  FIRSTROW = 2 -- If the first row contains column headers, use 2. Otherwise, use 1 or remove this line.
);

SELECT * FROM SeniorCitizen;

/*Copy SeniorCitizen(id,name,age)
--from ‪'E:\SeniorCitizen11.xls'
from ‪'E:\SeniorCitizen0.csv'
DELIMITER','
CSV HEADER; */
