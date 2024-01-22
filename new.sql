SELECT  activity_date AS day,
    count(DISTINCT user_id) AS active_users
FROM Activity
WHERE activity_date between '2019-06-28' and '2019-07-27'
group by activity_date
