# JavaNotes

JavaNotes is a learning app made of two parts:

- `todo_mobile`: Flutter client.
- `todo_service`: Spring Boot backend.

## Configuration

Sensitive runtime values are intentionally not committed. Configure them with environment variables.

### Backend

Common variables:

- `DB_URL`
- `DB_USERNAME`
- `DB_PASSWORD`
- `AI_SERVICE_MODE`
- `AI_LLM_API_KEY`
- `JWT_SECRET`
- `REDIS_HOST`
- `REDIS_PORT`

By default, the backend uses mock AI mode and local development services.

### Mobile

Pass the backend base URL when running Flutter:

```bash
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8080
```

