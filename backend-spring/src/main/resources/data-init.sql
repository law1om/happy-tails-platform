-- ============================================
-- Happy Tails - Auto-Init Data Script
-- Выполняется автоматически при запуске
-- ============================================

-- ПРИЮТЫ (создаем, если отсутствуют)
INSERT INTO shelters (name, description, address, phone, email, bank_account, created_at, updated_at)
SELECT 'Приют Самал', 'Городской приют Самал', 'г. Алматы, мкр. Самал-2, д. 25', '+7 727 000-00-01', 'samal@shelter.kz', 'KZ123456789SAMAL', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE NOT EXISTS (SELECT 1 FROM shelters WHERE name = 'Приют Самал');

INSERT INTO shelters (name, description, address, phone, email, bank_account, created_at, updated_at)
SELECT 'Центральный приют', 'Центральный приют города', 'г. Алматы, ул. Абая, 10', '+7 727 000-00-02', 'central@shelter.kz', 'KZ123456789CENTR', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE NOT EXISTS (SELECT 1 FROM shelters WHERE name = 'Центральный приют');

INSERT INTO shelters (name, description, address, phone, email, bank_account, created_at, updated_at)
SELECT 'Приют Надежда', 'Частный приют Надежда', 'г. Алматы, пр. Достык, 50', '+7 727 000-00-03', 'nadezhda@shelter.kz', 'KZ123456789NADEZ', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE NOT EXISTS (SELECT 1 FROM shelters WHERE name = 'Приют Надежда');

-- ЖИВОТНЫЕ (только если таблица пустая)
INSERT INTO animals (name, age, weight, breed, type, description, status, created_at, updated_at)
SELECT 'Акбай', 3, 28.5, 'Лабрадор', 'DOG', 'Дружелюбный и активный пес. Любит играть с детьми, хорошо обучен командам. Идеален для семьи с детьми. Привит, стерилизован.', 'AVAILABLE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE NOT EXISTS (SELECT 1 FROM animals WHERE name = 'Акбай');

INSERT INTO animals (name, age, weight, breed, type, description, status, created_at, updated_at)
SELECT 'Алпамыс', 5, 35.0, 'Немецкая овчарка', 'DOG', 'Умный и преданный пес. Отличный охранник и компаньон. Требует активных прогулок. Подходит для опытных владельцев.', 'AVAILABLE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE NOT EXISTS (SELECT 1 FROM animals WHERE name = 'Алпамыс');

INSERT INTO animals (name, age, weight, breed, type, description, status, created_at, updated_at)
SELECT 'Тобик', 2, 15.0, 'Джек-рассел-терьер', 'DOG', 'Энергичный и игривый малыш. Очень активный, любит бегать и играть. Подойдет для активных людей.', 'AVAILABLE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE NOT EXISTS (SELECT 1 FROM animals WHERE name = 'Тобик');

INSERT INTO animals (name, age, weight, breed, type, description, status, created_at, updated_at)
SELECT 'Сарыбай', 7, 25.0, 'Дворняга', 'DOG', 'Спокойный и ласковый пес. Найден на улице, очень благодарный. Хорошо ладит с другими животными.', 'AVAILABLE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE NOT EXISTS (SELECT 1 FROM animals WHERE name = 'Сарыбай');

INSERT INTO animals (name, age, weight, breed, type, description, status, created_at, updated_at)
SELECT 'Айдар', 4, 30.0, 'Хаски', 'DOG', 'Красивый голубоглазый хаски. Очень активный, любит бегать. Нуждается в длительных прогулках и внимании.', 'AVAILABLE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE NOT EXISTS (SELECT 1 FROM animals WHERE name = 'Айдар');

INSERT INTO animals (name, age, weight, breed, type, description, status, created_at, updated_at)
SELECT 'Нұрлан', 1, 12.0, 'Бигль', 'DOG', 'Молодой и веселый щенок. Очень любопытный и дружелюбный. Отлично подойдет для семьи.', 'AVAILABLE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE NOT EXISTS (SELECT 1 FROM animals WHERE name = 'Нұрлан');

-- Кошки
INSERT INTO animals (name, age, weight, breed, type, description, status, created_at, updated_at)
SELECT 'Ақмарал', 2, 4.5, 'Сиамская', 'CAT', 'Грациозная и элегантная кошечка. Очень общительная, любит внимание. Идеальна для квартиры.', 'AVAILABLE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE NOT EXISTS (SELECT 1 FROM animals WHERE name = 'Ақмарал');

INSERT INTO animals (name, age, weight, breed, type, description, status, created_at, updated_at)
SELECT 'Батыр', 4, 5.5, 'Британская короткошерстная', 'CAT', 'Спокойный и независимый кот. Хорошо переносит одиночество. Подходит для занятых людей.', 'AVAILABLE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE NOT EXISTS (SELECT 1 FROM animals WHERE name = 'Батыр');

INSERT INTO animals (name, age, weight, breed, type, description, status, created_at, updated_at)
SELECT 'Ақжелкен', 1, 3.0, 'Персидская', 'CAT', 'Пушистый белый котенок. Очень ласковый и игривый. Требует регулярного ухода за шерстью.', 'AVAILABLE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE NOT EXISTS (SELECT 1 FROM animals WHERE name = 'Ақжелкен');

INSERT INTO animals (name, age, weight, breed, type, description, status, created_at, updated_at)
SELECT 'Қызыл', 3, 4.8, 'Дворовая', 'CAT', 'Рыжий красавец с зелеными глазами. Найден на улице, очень ласковый и благодарный.', 'AVAILABLE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE NOT EXISTS (SELECT 1 FROM animals WHERE name = 'Қызыл');

INSERT INTO animals (name, age, weight, breed, type, description, status, created_at, updated_at)
SELECT 'Арыстан', 5, 6.0, 'Мейн-кун', 'CAT', 'Крупный и величественный кот. Спокойный характер, хорошо ладит с детьми.', 'AVAILABLE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE NOT EXISTS (SELECT 1 FROM animals WHERE name = 'Арыстан');

INSERT INTO animals (name, age, weight, breed, type, description, status, created_at, updated_at)
SELECT 'Айша', 2, 3.5, 'Шотландская вислоухая', 'CAT', 'Милая кошечка с необычными ушками. Очень спокойная и ласковая.', 'AVAILABLE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE NOT EXISTS (SELECT 1 FROM animals WHERE name = 'Айша');

-- Привязка животных к приютам (идемпотентно)
UPDATE animals SET shelter_id = (SELECT id FROM shelters WHERE name = 'Приют Самал')
WHERE name IN ('Акбай','Алпамыс','Тобик') AND (shelter_id IS NULL OR shelter_id <> (SELECT id FROM shelters WHERE name = 'Приют Самал'));

UPDATE animals SET shelter_id = (SELECT id FROM shelters WHERE name = 'Центральный приют')
WHERE name IN ('Сарыбай','Айдар','Нұрлан') AND (shelter_id IS NULL OR shelter_id <> (SELECT id FROM shelters WHERE name = 'Центральный приют'));

UPDATE animals SET shelter_id = (SELECT id FROM shelters WHERE name = 'Приют Надежда')
WHERE name IN ('Ақмарал','Батыр','Ақжелкен','Қызыл','Арыстан','Айша') AND (shelter_id IS NULL OR shelter_id <> (SELECT id FROM shelters WHERE name = 'Приют Надежда'));

-- СОБЫТИЯ (только если таблица пустая)
INSERT INTO events (title, description, event_date, location, max_participants, current_participants, status, created_at, updated_at)
SELECT 'День открытых дверей', 
 'Приглашаем всех желающих посетить наш приют! Вы сможете познакомиться с нашими питомцами, узнать об их историях и, возможно, найти нового друга. Будут проводиться экскурсии, мастер-классы по уходу за животными.', 
 CURRENT_TIMESTAMP + INTERVAL '7 days', 
 'г. Алматы, мкр. Самал-2, д. 25',
 50, 0, 'UPCOMING', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE NOT EXISTS (SELECT 1 FROM events LIMIT 1);

INSERT INTO events (title, description, event_date, location, max_participants, current_participants, status, created_at, updated_at)
SELECT 'Благотворительная ярмарка', 
 'Ярмарка в поддержку бездомных животных. Будут продаваться изделия ручной работы, выпечка, сувениры. Все средства пойдут на помощь приюту.', 
 CURRENT_TIMESTAMP + INTERVAL '14 days', 
 'Центральный парк культуры и отдыха им. Горького, Алматы',
 100, 0, 'UPCOMING', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE NOT EXISTS (SELECT 1 FROM events WHERE title = 'Благотворительная ярмарка');

INSERT INTO events (title, description, event_date, location, max_participants, current_participants, status, created_at, updated_at)
SELECT 'Мастер-класс по дрессировке', 
 'Профессиональный кинолог проведет мастер-класс по основам дрессировки собак. Узнайте, как правильно обучать своего питомца командам.', 
 CURRENT_TIMESTAMP + INTERVAL '21 days', 
 'г. Алматы, мкр. Самал-2, д. 25',
 30, 0, 'UPCOMING', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE NOT EXISTS (SELECT 1 FROM events WHERE title = 'Мастер-класс по дрессировке');

INSERT INTO events (title, description, event_date, location, max_participants, current_participants, status, created_at, updated_at)
SELECT 'Фотосессия с питомцами', 
 'Профессиональный фотограф проведет бесплатную фотосессию с нашими питомцами. Красивые фотографии помогут им быстрее найти дом!', 
 CURRENT_TIMESTAMP + INTERVAL '10 days', 
 'г. Алматы, мкр. Самал-2, д. 25',
 20, 0, 'UPCOMING', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE NOT EXISTS (SELECT 1 FROM events WHERE title = 'Фотосессия с питомцами');

INSERT INTO events (title, description, event_date, location, max_participants, current_participants, status, created_at, updated_at)
SELECT 'Волонтерский день', 
 'Приглашаем волонтеров помочь в уборке территории приюта, выгуле собак и уходе за животными. Будем рады любой помощи!', 
 CURRENT_TIMESTAMP + INTERVAL '5 days', 
 'г. Алматы, мкр. Самал-2, д. 25',
 40, 0, 'UPCOMING', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE NOT EXISTS (SELECT 1 FROM events WHERE title = 'Волонтерский день');

-- ФОТОГРАФИИ ЖИВОТНЫХ (добавляем фото для каждого животного)
-- Фото для собак
INSERT INTO photos (url, display_order, animal_id, created_at)
SELECT 'https://images.unsplash.com/photo-1552053831-71594a27632d?w=800', 0, a.id, CURRENT_TIMESTAMP
FROM animals a WHERE a.name = 'Акбай' AND NOT EXISTS (SELECT 1 FROM photos WHERE animal_id = a.id);

INSERT INTO photos (url, display_order, animal_id, created_at)
SELECT 'https://images.unsplash.com/photo-1568572933382-74d440642117?w=800', 0, a.id, CURRENT_TIMESTAMP
FROM animals a WHERE a.name = 'Алпамыс' AND NOT EXISTS (SELECT 1 FROM photos WHERE animal_id = a.id);

INSERT INTO photos (url, display_order, animal_id, created_at)
SELECT 'https://images.unsplash.com/photo-1477884213360-7e9d7dcc1e48?w=800', 0, a.id, CURRENT_TIMESTAMP
FROM animals a WHERE a.name = 'Тобик' AND NOT EXISTS (SELECT 1 FROM photos WHERE animal_id = a.id);

INSERT INTO photos (url, display_order, animal_id, created_at)
SELECT 'https://images.unsplash.com/photo-1543466835-00a7907e9de1?w=800', 0, a.id, CURRENT_TIMESTAMP
FROM animals a WHERE a.name = 'Сарыбай' AND NOT EXISTS (SELECT 1 FROM photos WHERE animal_id = a.id);

INSERT INTO photos (url, display_order, animal_id, created_at)
SELECT 'https://images.unsplash.com/photo-1605568427561-40dd23c2acea?w=800', 0, a.id, CURRENT_TIMESTAMP
FROM animals a WHERE a.name = 'Айдар' AND NOT EXISTS (SELECT 1 FROM photos WHERE animal_id = a.id);

INSERT INTO photos (url, display_order, animal_id, created_at)
SELECT 'https://images.unsplash.com/photo-1505628346881-b72b27e84530?w=800', 0, a.id, CURRENT_TIMESTAMP
FROM animals a WHERE a.name = 'Нұрлан' AND NOT EXISTS (SELECT 1 FROM photos WHERE animal_id = a.id);

-- Фото для кошек
INSERT INTO photos (url, display_order, animal_id, created_at)
SELECT 'https://images.unsplash.com/photo-1513360371669-4adf3dd7dff8?w=800', 0, a.id, CURRENT_TIMESTAMP
FROM animals a WHERE a.name = 'Ақмарал' AND NOT EXISTS (SELECT 1 FROM photos WHERE animal_id = a.id);

INSERT INTO photos (url, display_order, animal_id, created_at)
SELECT 'https://images.unsplash.com/photo-1596854407944-bf87f6fdd49e?w=800', 0, a.id, CURRENT_TIMESTAMP
FROM animals a WHERE a.name = 'Батыр' AND NOT EXISTS (SELECT 1 FROM photos WHERE animal_id = a.id);

INSERT INTO photos (url, display_order, animal_id, created_at)
SELECT 'https://images.unsplash.com/photo-1455103493930-a116f655b6c5?w=800', 0, a.id, CURRENT_TIMESTAMP
FROM animals a WHERE a.name = 'Ақжелкен' AND NOT EXISTS (SELECT 1 FROM photos WHERE animal_id = a.id);

INSERT INTO photos (url, display_order, animal_id, created_at)
SELECT 'https://images.unsplash.com/photo-1574158622682-e40e69881006?w=800', 0, a.id, CURRENT_TIMESTAMP
FROM animals a WHERE a.name = 'Қызыл' AND NOT EXISTS (SELECT 1 FROM photos WHERE animal_id = a.id);

INSERT INTO photos (url, display_order, animal_id, created_at)
SELECT 'https://images.unsplash.com/photo-1518791841217-8f162f1e1131?w=800', 0, a.id, CURRENT_TIMESTAMP
FROM animals a WHERE a.name = 'Арыстан' AND NOT EXISTS (SELECT 1 FROM photos WHERE animal_id = a.id);

INSERT INTO photos (url, display_order, animal_id, created_at)
SELECT 'https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?w=800', 0, a.id, CURRENT_TIMESTAMP
FROM animals a WHERE a.name = 'Айша' AND NOT EXISTS (SELECT 1 FROM photos WHERE animal_id = a.id);
