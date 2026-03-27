# PostgreSQL Setup for UrbanGreen

This project now supports both SQLite and PostgreSQL.

## 1) Install PostgreSQL driver

```powershell
pip install -r requirements-postgresql.txt
```

## 2) Create environment file

Copy `.env.example` to `.env` and edit database values:

```powershell
Copy-Item .env.example .env
```

Set these values in `.env`:

- `USE_POSTGRES=1`
- `POSTGRES_DB=urbangreen_db`
- `POSTGRES_USER=urbangreen_user`
- `POSTGRES_PASSWORD=your_password`
- `POSTGRES_HOST=127.0.0.1`
- `POSTGRES_PORT=5432`

## 3) Create PostgreSQL database and user

In `psql` (or pgAdmin query tool):

```sql
CREATE DATABASE urbangreen_db;
CREATE USER urbangreen_user WITH ENCRYPTED PASSWORD 'your_password';
GRANT ALL PRIVILEGES ON DATABASE urbangreen_db TO urbangreen_user;
```

## 4) Run migrations on PostgreSQL

```powershell
python manage.py migrate
```

## 5) Optional: move existing SQLite data to PostgreSQL

### 5.1 Export from SQLite

Set `USE_POSTGRES=0` temporarily in `.env`, then run:

```powershell
python manage.py dumpdata --natural-foreign --natural-primary -e contenttypes -e auth.permission > data.json
```

### 5.2 Import into PostgreSQL

Set `USE_POSTGRES=1` in `.env`, then run:

```powershell
python manage.py migrate
python manage.py loaddata data.json
```

## 6) Verify

```powershell
python manage.py check
python manage.py runserver
```

If server starts and pages load normally, PostgreSQL is active.
