# Happy Tails Backend - Spring Boot

## Описание
Backend для системы управления приютом животных на Java Spring Boot + PostgreSQL.

## Архитектура проекта

```
backend-spring/
├── src/main/java/com/happytails/
│   ├── HappyTailsApplication.java
│   ├── entity/           # JPA сущности
│   ├── dto/              # Data Transfer Objects
│   ├── repository/       # Spring Data JPA репозитории
│   ├── service/          # Бизнес-логика
│   ├── controller/       # REST контроллеры
│   ├── mapper/           # MapStruct маперы
│   ├── security/         # JWT и Security конфигурация
│   ├── exception/        # Обработка исключений
│   └── config/           # Конфигурация приложения
└── src/main/resources/
    ├── application.yml   # Конфигурация
    └── schema.sql        # SQL схема БД
```

## База данных

**Таблицы:**
- `users` - пользователи системы
- `animals` - животные в приюте
- `photos` - фотографии животных
- `events` - мероприятия
- `donations` - пожертвования

## API Endpoints

### Authentication
- `POST /api/auth/register` - регистрация
- `POST /api/auth/login` - вход
- `POST /api/auth/refresh` - обновление токена

### Animals
- `GET /api/animals` - список животных
- `GET /api/animals/{id}` - карточка животного
- `POST /api/animals` - создать (ADMIN)
- `PUT /api/animals/{id}` - обновить (ADMIN)
- `DELETE /api/animals/{id}` - удалить (ADMIN)

### Users
- `GET /api/users` - список пользователей (ADMIN)
- `GET /api/users/{id}` - получить пользователя
- `PUT /api/users/{id}` - обновить (ADMIN)
- `DELETE /api/users/{id}` - удалить (ADMIN)
- `PUT /api/users/{id}/block` - заблокировать (ADMIN)

### Events
- `GET /api/events` - список мероприятий
- `GET /api/events/{id}` - карточка мероприятия
- `POST /api/events` - создать (ADMIN)
- `PUT /api/events/{id}` - обновить (ADMIN)
- `DELETE /api/events/{id}` - удалить (ADMIN)

### Donations
- `GET /api/donations` - список донатов (ADMIN)
- `POST /api/donations` - отправить донат (USER)
- `GET /api/donations/my` - мои донаты (USER)

## Запуск

### Требования
- Java 17+
- Maven 3.8+
- PostgreSQL 14+

### Установка

1. Создать базу данных:
```sql
CREATE DATABASE happy_tails;
```

2. Настроить `application.yml` (при необходимости)

3. Запустить приложение:
```bash
mvn spring-boot:run
```

Приложение будет доступно на `http://localhost:8080`

## JWT Authentication

Все защищенные endpoints требуют JWT токен в заголовке:
```
Authorization: Bearer <token>
```

## Роли

- **ADMIN** - полный доступ ко всем операциям
- **USER** - просмотр и создание донатов

## ыТехнологии

- Spring Boot 3.2.0
- Spring Security + JWT
- Spring Data JPA
- PostgreSQL
- Lombok
- MapStruct
- Maven
