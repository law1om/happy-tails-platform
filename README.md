# Happy Tails - платформа для управления приютом для животных

Платформа для управления приютами, усыновлением животных, событиями и пожертвованиями.

## Назначение проекта

Проект разработан в учебных и портфолио целях и демонстрирует
навыки разработки клиент-серверного мобильного приложения
для социальной сферы.

## Технологии

### Backend
- **Java 17+**
- **Spring Boot 3.x** (Security, Data JPA, Web)
- **PostgreSQL** - основная БД
- **Flyway** - миграции БД
- **MapStruct** - маппинг DTO
- **JWT** - аутентификация
- **BCrypt** - хеширование паролей
- **Maven** - сборка

### Frontend
- **Flutter 3.x**
- **Dart 3.x**
- **HTTP** - REST API клиент
- **SharedPreferences** - локальное хранилище

---

## Запуск и требования

### Backend
- Java 17 или выше
- Maven 3.8+
- PostgreSQL 14+

### Frontend
- Flutter SDK 3.0+
- Dart SDK 3.0+

---


### 1. Клонирование репозитория

```bash
git clone <repository-url>
cd happyhappy
```

### 2. Настройка базы данных

-- Создайте базу данных
CREATE DATABASE happy_tails;


### 3. Настройка Backend

```bash
cd backend-spring

mvn clean install
mvn spring-boot:run
```

**Backend запустится на:** `http://localhost:8080`

### 4. Настройка Frontend

```bash
cd fronthappy

flutter pub get


flutter run
```

## Структура проекта

```
happyhappy/
├── backend-spring/          # Spring Boot backend
│   ├── src/
│   │   ├── main/
│   │   │   ├── java/com/happytails/
│   │   │   │   ├── config/          # Конфигурация (Security, DataInitializer)
│   │   │   │   ├── controller/      # REST контроллеры
│   │   │   │   ├── dto/             # Data Transfer Objects
│   │   │   │   ├── entity/          # JPA сущности
│   │   │   │   ├── exception/       # Обработка ошибок
│   │   │   │   ├── mapper/          # MapStruct маппинг
│   │   │   │   ├── repository/      # Spring Data репозитории
│   │   │   │   ├── security/        # JWT, UserDetails
│   │   │   │   └── service/         # Бизнес-логика
│   │   │   └── resources/
│   │   │       ├── application.yml  # Конфигурация приложения
│   │   │       ├── data-init.sql    # Начальные данные
│   │   │       └── db/migration/    # Flyway миграции
│   │   └── test/                    # Тесты
│   ├── .env.example                 # Пример переменных окружения
│   └── pom.xml                      # Maven зависимости
│
└── fronthappy/              # Flutter frontend
    ├── lib/
    │   ├── models/          # Модели данных
    │   ├── screens/         # UI экраны
    │   └── services/        # API сервисы
    ├── pubspec.yaml         # Flutter зависимости
    └── web/                 # Web конфигурация
```


## Тестовые данные

После запуска backend автоматически создаются:

### Пользователи

| Email | Пароль | Роль |
|-------|--------|------|
| `admin@happytails.com` | `admin123` | ADMIN |
| `ramil@tails.com` | `123123` | USER |

### Приюты
- Приют Самал
- Центральный приют
- Приют Надежда

### Животные
12 животных (собаки и кошки) с фотографиями и привязкой к приютам

### События
5 предстоящих событий (День открытых дверей, Благотворительная ярмарка и др.)


