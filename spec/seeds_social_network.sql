TRUNCATE TABLE posts, users RESTART IDENTITY;

INSERT INTO users (name, email) VALUES ('David', 'david@makers.com');
INSERT INTO users (name, email) VALUES ('Anna', 'anna@makers.com');


INSERT INTO posts (title, content, number_of_views, user_id) VALUES ('First Day', 'Today was a great day.', 132, 1);
INSERT INTO posts (title, content, number_of_views, user_id) VALUES ('Learning SQL', 'I have learned so much.', 472, 2);