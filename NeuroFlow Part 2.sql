--- 1. How many users completed an exercise in their first month per monthly cohort?

--- In this question I am making the assumption that we are only looking at one year of data (e.g. only 2018)

SELECT
  monthly_cohort,
  ROUND(100 * (num_first_month / num_users),2) AS completion_pct
FROM

(SELECT
  DATE_PART('month', users.created_at) AS monthy_cohort,
COUNT(DISTINCT users.user_id) FILTER(
    WHERE DATE_PART('month', users.created_at) = DATE_PART('month', exercises.exercise_completion_date)) AS num_first_month
COUNT(DISTINCT users.user_id) AS num_users
FROM users
  LEFT JOIN exercises
ON users.user_id = exercises.user_id
GROUP BY DATE_PART('month', users.created_at)) AS subquery

GROUP BY monthly_cohort
ORDER BY completion_pct DESC;


--- 2. How many users completed a given amount of exercises?

WITH user_frequency AS (
SELECT
  users.user_id,
  COUNT(DISTINCT exercises.exercise_id) AS exercise_count
FROM users
  LEFT JOIN exercises
ON users.user_id = exercises.user_id)

SELECT
  exercise_count,
  COUNT(DISTINCT user_id) as num_users
FROM user_frequency
GROUP BY exercise_count;


--- 3. Which organizations have the most severe patient population?

SELECT
  providers.organization_name,
  AVG(Phq9.score) AS average_score
FROM Phq9
  LEFT JOIN providers
ON Phq9.provider_id = Providers.provider_id
GROUP BY Providers.organization_name
ORDER BY average_score DESC
LIMIT 5