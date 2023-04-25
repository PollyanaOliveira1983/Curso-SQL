SELECT * FROM patients;


select first_name, last_name, gender
from patients
where gender = 'M';

select first_name, last_name
from patients
where allergies ISNUll;

select first_name
from patients
where first_name like 'C%';

select first_name, last_name
from patients
where weight between 100 and 120;

update patients set allergies = 'NKA'
where allergies is null;

select concat(first_name, " ", last_name) AS NOME_COMPLETO
from patients; 

select p.first_name, p.last_name, pn.province_name
from patients p 
join province_names pn 
ON p.province_id = pn.province_id
;

select p.first_name, p.last_name, pn.province_name
from patients p 
join province_names pn 
ON p.province_id = pn.province_id
;

select COUNT(*) AS num_patients
from patients
where YEAR(birth_date) = 2010;

select first_name, last_name, Max(height)
from patients
;

select *
from patients
where patient_id In (1,45,534,879,1000)

select COUNT(*)
from admissions;


select patient_id, COUNT(*) as total_admissinos
from admissions
where patient_id = 579;

select Distinct(city) as unique_cities
from patients
where province_id = 'NS';

select first_name, last_name, birth_date
from patients
where height > 160 and weight > 70;

select first_name, last_name, allergies
from patients
where city = 'Hamilton' and
allergies not null;

select Distinct(city)
from patients
where 
	city LIKE 'a%' OR 
    	city LIKE 'e%' OR 
    	city LIKE 'i%' OR 
    	city LIKE 'o%' OR 
    	city LIKE 'u%'
order by city ASC;

select Distinct YEAR(birth_date) as birth_year
from patients
order by birth_year ASC;

==================================================

SELECT
  patient_id,
  first_name
FROM patients
WHERE first_name LIKE 's____%s';

SELECT
  patient_id,
  first_name
FROM patients
WHERE
  first_name LIKE 's%s'
  AND len(first_name) >= 6;

SELECT
  patient_id,
  first_name
FROM patients
where
  first_name like 's%'
  and first_name like '%s'
  and len(first_name) >= 6;

SELECT patient_id, first_name
FROM patients
WHERE first_name LIKE 's___%s' AND LENGTH(first_name) >= 6;

=======================================================

select p.patient_id, p.first_name, p.last_name
from patients p
join admissions a on p.patient_id = a.patient_id
where a.diagnosis = 'Dementia';

========================================================

Display every patient's first_name.
Order the list by the length of each name and then by alphbetically

select first_name
from patients
order by LENGTH(first_name), first_name ASc ;

///

SELECT first_name
FROM patients
order by
  len(first_name),
  first_name;

==========================================================

Show the total amount of male patients and the total amount of female patients in the patients table.
Display the two results in the same row.

select 
	(select count(*) from patients where gender = 'M') as male_count,
	(select count(*) from patients where gender = 'F') as female_count;

===============================================================================

Show first and last name, allergies from patients which have allergies to either 'Penicillin' or 'Morphine'. Show results ordered ascending by allergies then by first_name then by last_name.


SELECT
  first_name,
  last_name,
  allergies
FROM patients
WHERE
  allergies IN ('Penicillin', 'Morphine')
ORDER BY
  allergies,
  first_name,
  last_name;
//

select last_name, first_name, allergies
from patients
where allergies in('Penicillin', 'Morphine')
order by allergies Asc, first_name ASC, last_name ASC;

======================================================================

Show patient_id, diagnosis from admissions. Find patients admitted multiple times for the same diagnosis

SELECT
  patient_id,
  diagnosis
FROM admissions
GROUP BY
  patient_id,
  diagnosis
HAVING COUNT(*) > 1;

///

select patient_id, diagnosis
from admissions
group by patient_id, diagnosis
having count(*) > 1
order by patient_id, diagnosis

===============================================================

select city, Count(*) as num_patients 
from patients
group by city
order by num_patients Desc, city asc


================================================================

first name, last name and role of every person that is either patient or doctor.
The roles are either "Patient" or "Doctor"


select first_name, last_name, 'Patient' as role
from patients
Union all
select first_name, last_name, 'Doctor' as role
from doctors;

==================================================================

select
	allergies, 
    count(allergies) as total_diagnosis
from patients
where allergies not null
group by allergies
order by total_diagnosis desc

=====================================================================
Show all patient's first_name, last_name, and birth_date who were born in the 1970s decade. 
Sort the list starting from the earliest birth_date.

select
	first_name,
    last_name,
    birth_date
from patients
where YEAR(birth_date) between 1970 and 1979
order by birth_date Asc;

========================================================================
We want to display each patient's full name in a single column. Their last_name in all upper letters must appear first, 
then first_name in all lower case letters. Separate the last_name and first_name with a comma. Order the list by the first_name 
in decending order
EX: SMITH,jane

select 
	Concat(upper(last_name),',', Lower(first_name)) as new_name_format
from patients
order by first_name desc
;

=========================================================================

Show the province_id(s), sum of height; where the total sum of its patient's height is greater than or equal to 7,000.

select
	province_id,
    sum(height) as sum_height
from patients
group by province_id
having sum_height >= 7000
;

============================================================================

Show the difference between the largest weight and smallest weight for patients with the last name 'Maroni'

select
	Max(weight) - Min(weight) as weight_delta
from patients
where last_name = 'Maroni'
;

=================================================================================

Show all of the days of the month (1-31) and how many admission_dates occurred on that day. Sort by the day with most admissions to least admissions.


select
	day(admission_date) as day_number,
    Count(*) as number_of_admissions
from admissions
group by day(admission_date)
order by number_of_admissions Desc

===================================================================================

Show all columns for patient_id 542's most recent admission_date.


SELECT *
FROM admissions
WHERE patient_id = 542
ORDER BY admission_date DESC
LIMIT 1;

SELECT *
FROM admissions
WHERE patient_id = 542
GROUP BY patient_id
HAVING
  admission_date = MAX(admission_date);

SELECT *
FROM admissions
WHERE
  patient_id = '542'
  AND admission_date = (
    SELECT MAX(admission_date)
    FROM admissions
    WHERE patient_id = '542'
  )
;

SELECT *
FROM admissions
GROUP BY patient_id
HAVING
  patient_id = 542
  AND max(admission_date);

=====================================================================================

Show patient_id, attending_doctor_id, and diagnosis for admissions that match one of the two criteria:
1. patient_id is an odd number and attending_doctor_id is either 1, 5, or 19.
2. attending_doctor_id contains a 2 and the length of patient_id is 3 characters.


select patient_id,
	attending_doctor_id,
    diagnosis
from
	admissions
WHERE (
        attending_doctor_id IN (1, 5, 19)
        AND patient_id % 2 != 0
      )
     OR
     (
     	  attending_doctor_id LIKE '%2%' 
        AND LENGTH(patient_id) = 3
      )
;  

=============================================================================================

Show first_name, last_name, and the total number of admissions attended for each doctor. 
Every admission has been attended by a doctor.


SELECT
  first_name,
  last_name,
  count(*)
from
  doctors p,
  admissions a
where
  a.attending_doctor_id = p.doctor_id
group by p.doctor_id;


select first_name, last_name, count(*) as admissions_total
from admissions a
join doctors dr on dr.doctor_id = a.attending_doctor_id
group by first_name;

====================================================================================================

For each doctor, display their id, full name, and the first and last admission date they attended.

select 
	doctor_id, 
    Concat(first_name,' ',last_name) as full_name,
    Min(admission_date) as first_admission_date,
    Max(admission_date) as last_admission_date
from doctors
join admissions on doctor_id = admissions.attending_doctor_id
group by doctor_id



select
  doctor_id,
  first_name || ' ' || last_name as full_name,
  min(admission_date) as first_admission_date,
  max(admission_date) as last_admission_date
from admissions a
  join doctors ph on a.attending_doctor_id = ph.doctor_id
group by doctor_id;


=======================================================================================================

Display the total amount of patients for each province. Order by descending.

select 
	province_name,
    Count(*) as patient_count
from province_names
join patients on patients.province_id = province_names.province_id
group by province_name
order By patient_count desc;

SELECT
  province_name,
  COUNT(*) as patient_count
FROM patients pa
  join province_names pr on pr.province_id = pa.province_id
group by pr.province_id
order by patient_count desc;

==========================================================================================================

For every admission, display the patient's full name, their admission diagnosis, and their doctor's full name who diagnosed their problem.

select 
	p.first_name || ' ' || p.last_name as patient_name,
    a.diagnosis,
    d.first_name || ' ' || d.last_name as doctor_name
from patients p
join admissions a on a.patient_id = p.patient_id
inner join doctors d on d.doctor_id = a.attending_doctor_id

SELECT
  CONCAT(patients.first_name, ' ', patients.last_name) as patient_name,
  diagnosis,
  CONCAT(doctors.first_name,' ',doctors.last_name) as doctor_name
FROM patients
  JOIN admissions ON admissions.patient_id = patients.patient_id
  JOIN doctors ON doctors.doctor_id = admissions.attending_doctor_id;

==========================================================================================================

display the number of duplicate patients based on their first_name and last_name.

select first_name, last_name, Count(*) num_of_duplicate
from patients
group by first_name, last_name
HAVING COUNT(*) > 1;


============================================================================================================

Display patient's full name, height in the units feet rounded to 1 decimal, weight in the unit pounds rounded to 0 decimals,
birth_date, gender non abbreviated. Convert CM to feet by dividing by 30.48. Convert KG to pounds by multiplying by 2.205.

/*A função ROUND é usada para arredondar a altura em centímetros para a unidade de pés arredondado para uma casa decimal. 
A função ROUND também é usada para arredondar o peso em quilogramas para a unidade de libras sem casas decimais.*/


select 
	concat(first_name, ' ', last_name) as patient_name,
    ROUND(height/30.48, 1) AS height,
    ROUND(weight*2.205, 0) AS weight,
    birth_date,
    Case gender
    	When 'M' then 'MALE'
        WHEN 'F' THEN 'FEMALE'
    End AS gender_type
from patients;


=============================================================================================================

Show all of the patients grouped into weight groups.
Show the total amount of patients in each weight group.
Order the list by the weight group decending.
For example, if they weight 100 to 109 they are placed in the 100 weight group, 110-119 = 110 weight group, etc.

/*A expressão "floor(weight / 10) * 10" é usada para arredondar o peso de cada paciente para a dezena mais próxima. 
Por exemplo, um paciente com peso 73 seria agrupado com outros pacientes com pesos entre 70 e 79. 
A cláusula AS é usada para renomear essa coluna de resultado para "weight_group".*/

select 
	Count(weight) As patients_in_group,
	floor(weight / 10) * 10 as weight_group	 
from patients
group by weight_group
order by weight Desc;

=========================================================================================================

Show patient_id, weight, height, isObese from the patients table. Display isObese as a boolean 0 or 1.
Obese is defined as weight(kg)/(height(m)2) >= 30. 
weight is in units kg.
height is in units cm.

select patient_id, weight, height,
	case 
     when weight/(Power(height/100.0,2)) >= 30 then 1
     else 0
	end IsObese                     
from patients

========================================================================================================

Show patient_id, first_name, last_name, and attending doctor's specialty.
Show only the patients who has a diagnosis as 'Epilepsy' and the doctor's first name is 'Lisa'
Check patients, admissions, and doctors tables for required information.

select 
	p.patient_id, 
    p.first_name as patients_first_name, 
    p.last_name as patients_last_name,
    specialty as attending_doctor_specialty
from patients p
join admissions a On p.patient_id = a.patient_id
join doctors dr on dr.doctor_id = a.attending_doctor_id
where a.diagnosis = 'Epilepsy' and dr.first_name = 'Lisa'

===========================================================================================================

All patients who have gone through admissions, can see their medical documents on our site. Those patients are given a temporary password after their first admission. Show the patient_id and temp_password.
The password must be the following, in order: 1. patient_id / 2. the numerical length of patient's last_name / 3. year of patient's birth_date

select 
	distinct p.patient_id,
	CONCAT(p.patient_id, LENGTH(p.last_name), YEAR(p.birth_date)) AS temp_password
from patients p
join admissions a on p.patient_id = a.patient_id

===========================================================================================================

Each admission costs $50 for patients without insurance, and $10 for patients with insurance. All patients with an even patient_id have insurance.
Give each patient a 'Yes' if they have insurance, and a 'No' if they don't have insurance. 
Add up the admission_total cost for each has_insurance group.

select 
	case 
    	when patient_id %2 = 0 then 'Yes'
    	else 'No'
    	End as has_insurance,
    sum(
      case
       	WHEN patient_id % 2 = 0 THEN 10 
      	ELSE 50
      END) AS admission_total
from admissions
GROUP BY has_insurance;


SELECT
  has_insurance,
  CASE
    WHEN has_insurance = 'Yes' THEN COUNT(has_insurance) * 10
    ELSE count(has_insurance) * 50
  END AS cost_after_insurance
FROM (
    SELECT
      CASE
        WHEN patient_id % 2 = 0 THEN 'Yes'
        ELSE 'No'
      END AS has_insurance
    FROM admissions
  )
GROUP BY has_insurance


===============================================================================================================

Show the provinces that has more patients identified as 'M' than 'F'. Must only show full province_name

/* A consulta agrupa os pacientes por "province_name" e usa a cláusula HAVING para filtrar as linhas em que o 
número de pacientes do sexo masculino é maior do que o número de pacientes do sexo feminino. A consulta 
retorna o nome completo de cada província que atende a esse critério.*/

select distinct pn.province_name
from patients p
join province_names pn on p.province_id = pn.province_id
group by pn.province_name
HAVING COUNT(
  CASE WHEN gender = 'M' THEN 1 
 	   END) > 
  COUNT(
    CASE WHEN gender = 'F' THEN 1 
    	 END)


SELECT province_name
FROM (
    SELECT
      province_name,
      SUM(gender = 'M') AS n_male,
      SUM(gender = 'F') AS n_female
    FROM patients pa
      JOIN province_names pr ON pa.province_id = pr.province_id
    GROUP BY province_name
  )
WHERE n_male > n_female

========================================================================================

We are looking for a specific patient. Pull all columns for the patient who matches the following criteria:
- First_name contains an 'r' after the first two letters.
- Identifies their gender as 'F'
- Born in February, May, or December
- Their weight would be between 60kg and 80kg
- Their patient_id is an odd number
- They are from the city 'Kingston'

select *
from patients
where 
	first_name like '__r%'
	AND Gender = 'F'
    AND MONTH(Birth_date) IN (2, 5, 12)
    AND Weight BETWEEN 60 AND 80
    AND patient_id % 2 = 1
    AND City = 'Kingston'

SELECT *
FROM patients
WHERE 
    SUBSTR(First_name, 3, 1) = 'r'
    AND Gender = 'F'
    AND MONTH(Birth_date) IN (2, 5, 12)
    AND Weight BETWEEN 60 AND 80
    AND patient_id % 2 = 1
    AND City = 'Kingston'

============================================================================================

Show the percent of patients that have 'M' as their gender. Round the answer to the nearest hundreth number and in percent form.

SELECT Concat(
  ROUND(
  (
    SELECT COUNT(*)
 	FROM patients
  	WHERE Gender = 'M'
  ) / CAST(COUNT(*) AS FLOAT) * 100, 2)
, '%') AS percent_of_male_patients
FROM patients;


SELECT CONCAT(
    ROUND(
      (
        SELECT COUNT(*)
        FROM patients
        WHERE gender = 'M'
      ) / CAST(COUNT(*) as float),
      2
    ) * 100,
    '%'
  ) as percent_of_male_patients
FROM patients;

=============================================================================================

For each day display the total amount of admissions on that day. Display the amount changed from the previous date.

WITH admissions_count AS ( 
  SELECT admission_date, COUNT(*) AS admission_day
  FROM admissions 
  GROUP BY admission_date
)
SELECT 
  admission_date, 
  admission_day, 
 COUNT(admission_date) - lag(count(admission_date)) 
 over (order by admission_date) as admission_count_change
FROM 
  admissions_count
ORDER BY 
  admission_date DESC;

==============================================================================================

