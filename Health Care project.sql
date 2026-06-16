SELECT * FROM `healthcare-project`.ocd_patient;
-- the questions that we gonna answer
  -- 1  count of patients by gender and their average obs score;
               SELECT Gender,
                    count(`Patient ID`) as patient_count,
                    round(AVG(`Y-BOCS Score (Obsessions)`),2) as avg_obs_score
               FROM ocd_patient
               GROUP BY Gender;
               
  -- 2  from 1 above  calculate patients percentages
       WITH gender_count AS
			(SELECT Gender,
                    count(`Patient ID`) as patient_count,
                    round(AVG(`Y-BOCS Score (Obsessions)`),2) as avg_obs_score
               FROM ocd_patient
               GROUP BY Gender),
		TOTAL AS 
           (SELECT 
           SUM(patient_count) AS total_count
           FROM gender_count)
	SELECT
             g.Gender,
             g.patient_count,
             g.avg_obs_score,
     CONCAT(
        ROUND(((patient_count/t.total_count)*100),2), '%'
               ) AS percentage
      FROM gender_count g
      JOIN total t;
  -- 3  counts of patiennts mom
  SET  sql_safe_updates=0;
  
        UPDATE ocd_patient
        SET `OCD Diagnosis Date` = STR_TO_DATE(`OCD Diagnosis Date`, '%Y-%m-%d')
        WHERE `OCD Diagnosis Date` IS NOT NULL;

 ALTER TABLE ocd_patient
MODIFY COLUMN `OCD Diagnosis Date` DATE;

SELECT date_format(`OCD Diagnosis Date`,'%Y-%m-01 00:00:00') AS months,
     count(`Patient ID`) AS patient_count
     FROM ocd_patient
     GROUP BY months
     ORDER BY months;


  -- 4  most common obs types and their average obs core
   
   UPDATE ocd_patient
SET `OCD Diagnosis Date` =
    STR_TO_DATE(`OCD Diagnosis Date`, '%Y-%m-%d')
WHERE `OCD Diagnosis Date` IS NOT NULL;
  SELECT 
  `Obsession Type`,
   COUNT(`Patient ID`) AS patient_count,
   ROUND(AVG(`Y-BOCS Score (Obsessions)`), 2) AS avg_obs_score
   FROM ocd_patient
   GROUP BY 1
   ORDER BY 2 DESC;
   
  -- 5 most common comp types and its average comp score
  SELECT 
  `Compulsion Type`,
   COUNT(`Patient ID`) AS patient_count,
   ROUND(AVG(`Y-BOCS Score (Compulsions)`), 2) AS avg_comp_score
   FROM ocd_patient
   GROUP BY 1
   ORDER BY 2 DESC;