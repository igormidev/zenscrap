**ALWAYS use the experimental features flag when generating Serverpod files:**

```bash
serverpod generate --experimental-features=all
```

To reset on client: 
serverpod generate --experimental-features=all && serverpod create-migration --experimental-features=all --force && docker compose down -v --volumes --remove-orphans && docker compose up --build --detach && dart run bin/main.dart --apply-migrations