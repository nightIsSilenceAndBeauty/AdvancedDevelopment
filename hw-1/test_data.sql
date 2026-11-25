-- Роли
INSERT INTO roles (name)
VALUES
    ('administrator'),
    ('producer'),
    ('subscriber'),
    ('user');

-- Тестовые пользователи
INSERT INTO users (first_name, last_name, email, phone_number, password)
VALUES
    ('Алексей', 'Орлов',    'user0@example.com', '+70000000000', 'pass0'),
    ('Мария',   'Соколова', 'user1@example.com', '+70000000001', 'pass1'),
    ('Иван',    'Кузнецов', 'user2@example.com', '+70000000002', 'pass2');

-- Базовая роль user для каждого пользователя
INSERT INTO user_role (user_id, role_id)
SELECT u.id, r.id
FROM users AS u
JOIN roles AS r ON r.name = 'user';

-- Дополнительные роли пользователей
INSERT INTO user_role (user_id, role_id)
SELECT u.id, r.id
FROM (VALUES
    ('user0@example.com', 'administrator'),
    ('user1@example.com', 'producer'),
    ('user2@example.com', 'subscriber')
) AS assigned(email, role_name)
JOIN users AS u ON lower(u.email) = assigned.email
JOIN roles AS r ON r.name = assigned.role_name;
-- Тестовые сообщения
INSERT INTO messages (author_id, text)
VALUES
    (2, 'Открытая лекция начнётся в пятницу в 18:00.'),
    (2, 'Добавил материалы к сегодняшней встрече.'),
    (1, 'В воскресенье проведём прогулку по набережной.');

-- Тестовые реакции
INSERT INTO reactions (message_id, user_id, type)
VALUES
    (1, 2, 'like'),
    (2, 3, 'heart'),
    (3, 2, 'wow');

-- Тестовые подписки
INSERT INTO subscriptions (subscriber_id, producer_id)
VALUES
    (3, 2),
    (1, 2),
    (3, 1);

-- Назначить пользователю дополнительную роль
INSERT INTO user_role (user_id, role_id)
SELECT u.id, r.id
FROM users u
JOIN roles r ON r.name = 'producer'
WHERE u.email = 'user2@example.com';

-- Изменить текст сообщения
UPDATE messages
SET text = 'Открытая лекция начнётся в пятницу в 19:00.'
WHERE id = 1;

-- Изменить тип реакции
UPDATE reactions
SET type = 'laugh'
WHERE message_id = 1 AND user_id = 2;

-- Удалить одну реакцию
DELETE FROM reactions
WHERE message_id = 3 AND user_id = 2;

-- Удалить одну подписку
DELETE FROM subscriptions
WHERE subscriber_id = 1 AND producer_id = 2;

-- Показать сообщения с авторами
SELECT m.id, m.text, u.first_name, u.last_name, m.created_at
FROM messages AS m
JOIN users AS u ON u.id = m.author_id
ORDER BY m.created_at DESC;

-- Показать роли пользователей
SELECT u.first_name, u.last_name, r.name AS role
FROM users AS u
JOIN user_role AS ur ON ur.user_id = u.id
JOIN roles AS r ON r.id = ur.role_id
ORDER BY u.id, r.name;

-- Показать подписки пользователя
SELECT s.subscriber_id, s.producer_id, s.created_at
FROM subscriptions AS s
WHERE s.subscriber_id = 3;

-- Посчитать реакции на сообщения
SELECT message_id, COUNT(*) AS reactions_count
FROM reactions
GROUP BY message_id;

