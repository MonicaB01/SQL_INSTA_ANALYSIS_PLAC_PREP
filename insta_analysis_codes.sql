select* from users;
select * from photos;
select* from comments;
select* from follows;
select* from likes;
select* from tags;
select* from photo_tags;

----- MARKETING ANALYSIS------

----- A. LOYAL USERS--------

select*from users;

SELECT * FROM users
ORDER BY created_at ASC
LIMIT 5;

---- B.INACTIVE_USERS ------

select* from photos;

SELECT * FROM users u
LEFT JOIN photos p ON u.id = p.user_id
WHERE p.id IS NULL;


---- C.CONTEST WINNER DECLARATION -----

select*from likes;

SELECT photo_id, COUNT(user_id) AS like_count
FROM likes
GROUP BY photo_id;

select*from users;



SELECT p.id, u.id, u.username, like_counts.like_count
FROM (
    SELECT photo_id, COUNT(user_id) AS like_count
    FROM likes
    GROUP BY photo_id
    ORDER BY like_count DESC
    LIMIT 1
) AS like_counts
JOIN photos p ON p.id = like_counts.photo_id
JOIN users u ON p.user_id = u.id;


--- D. MOST_POPULAR_HASHTAGS ----

select* from tags;

SELECT tag_name, COUNT(*) AS tag_count
FROM tags
GROUP BY tag_name
ORDER BY tag_count DESC
LIMIT 5;

select* from photo_tags;

SELECT t.id, t.tag_name, tag_counts.tag_count
FROM (
    SELECT tag_id, COUNT(photo_id) AS tag_count
    FROM photo_tags
    GROUP BY tag_id
) AS tag_counts
JOIN tags t ON t.id = tag_counts.tag_id
ORDER BY tag_counts.tag_count DESC
LIMIT 5;

------ E.AD CAMPAIGN LAUNCH -----

---- 1.LIKES ----

SELECT 
    DAYOFWEEK(created_at) AS day_of_week, 
    COUNT(*) AS likes_count
FROM likes
GROUP BY day_of_week;

---- 2. photos ------

SELECT 
    DAYOFWEEK(created_dat) AS day_of_week, 
    COUNT(*) AS photos_count
FROM photos
GROUP BY day_of_week;

----- 3. users ------

SELECT 
    DAYOFWEEK(created_at) AS day_of_week, 
    COUNT(*) AS users_count
FROM users
GROUP BY day_of_week;

------ 4. follows ----

SELECT 
    DAYOFWEEK(created_at) AS day_of_week, 
    COUNT(*) AS follows_count
FROM follows
GROUP BY day_of_week;

---- 5. comments ----

SELECT 
    DAYOFWEEK(created_at) AS day_of_week, 
    COUNT(*) AS comments_count
FROM comments
GROUP BY day_of_week;

---- 6.tags ----

SELECT 
    DAYOFWEEK(created_at) AS day_of_week, 
    COUNT(*) AS tags_count
FROM tags
GROUP BY day_of_week;

---- Union ----

SELECT 
    day_of_week, 
    SUM(likes_count) AS total_likes,
    SUM(photos_count) AS total_photos,
    SUM(comments_count) AS total_comments,
    SUM(follows_count) AS total_follows,
    SUM(tags_count) AS total_tags,
    (SUM(likes_count) + SUM(photos_count) + SUM(comments_count) + SUM(follows_count) + SUM(tags_count)) AS total_engagement
FROM (
    SELECT 
        DAYOFWEEK(created_at) AS day_of_week, 
        COUNT(*) AS likes_count,
        0 AS photos_count,
        0 AS comments_count,
        0 AS follows_count,
        0 AS tags_count
    FROM likes
    GROUP BY day_of_week
    UNION ALL
    SELECT 
        DAYOFWEEK(created_dat) AS day_of_week, 
        0 AS likes_count,
        COUNT(*) AS photos_count,
        0 AS comments_count,
        0 AS follows_count,
        0 AS tags_count
    FROM photos
    GROUP BY day_of_week
    UNION ALL
    SELECT 
        DAYOFWEEK(created_at) AS day_of_week, 
        0 AS likes_count,
        0 AS photos_count,
        COUNT(*) AS comments_count,
        0 AS follows_count,
        0 AS tags_count
    FROM comments
    GROUP BY day_of_week
    UNION ALL
    SELECT 
        DAYOFWEEK(created_at) AS day_of_week, 
        0 AS likes_count,
        0 AS photos_count,
        0 AS comments_count,
        COUNT(*) AS follows_count,
        0 AS tags_count
    FROM follows
    GROUP BY day_of_week
    UNION ALL
    SELECT 
        DAYOFWEEK(created_at) AS day_of_week, 
        0 AS likes_count,
        0 AS photos_count,
        0 AS comments_count,
        0 AS follows_count,
        COUNT(*) AS tags_count
    FROM tags
    GROUP BY day_of_week
) AS combined_counts
GROUP BY day_of_week
ORDER BY total_engagement DESC;

----- INVESTOR METRICS ----

--- A. USER ENGAGEMENT ----

--- average no. of posts ----

SELECT COUNT(*) AS total_photos
FROM photos;

SELECT COUNT(*) AS total_users
FROM users;

SELECT 
    (SELECT COUNT(*) FROM photos) / (SELECT COUNT(*) FROM users) AS average_posts_per_user;
    
    ---- B. BOTS AND FAKE ACCOUNTS ---
    
SELECT u.id, u.username
FROM (
    SELECT user_id, COUNT(photo_id) AS like_count
    FROM likes
    GROUP BY user_id
) AS user_likes
JOIN users u ON u.id = user_likes.user_id
WHERE user_likes.like_count = (SELECT COUNT(*) FROM photos);
    
