---
name: admin-supabase-data-backend
description: How the e-sports-admin app reads/writes match data and the manual Supabase setup it needs
metadata:
  type: project
---

The `e-sports-admin` Flutter app (pubspec name `clean_boilerplate`) does all data entry directly against **Supabase** (Postgrest + Storage) via `SupabaseClient`, registered in Injectable DI through `lib/core/network/supabase_module.dart`. Auth/config still go through the Dio `ApiClient`. Supabase URL/anon key live in `AppConstants` (same project as the consumer app).

Built modules (clean arch: entity → model → datasource → repository → usecases → BLoC → screen): season, player (with image upload), match (season-scoped), match_entry (the core per-player stat entry, upsert on `playerId,matchId`), business_setup (the single `app_settings` row + current-season picker). New BLoCs are provided per-screen via `getIt`, not globally in `main.dart`.

DB columns are **lowercase** (verified against live schema): `profileimageurl`, `jerseynumber`, `playerroles`, `customtags`, `createdat`, `hometeam`, `awayteam`, `homescore`, `awayscore`, `playerid`, `matchid`, `goalsconceded`, `cleansheet`, `motm`, `cleansheets`, `motmcount`, `avgrating`. Postgres folded the DDL's unquoted camelCase. Admin models map these exact lowercase keys (the consumer app reads camelCase keys, e.g. `json['jerseyNumber']`, so those are likely latent-null bugs there — not fixed per instruction). `matches` uses `season_id` (consumer app's `backend_data_controller` still queries a legacy `season` column).

`matches.status` CHECK allows `upcoming / live / finished / cancelled` (`completed` was renamed to `finished` via ALTER TABLE). `match_entries.result` allows `win / loss / draw`. Admin `kMatchStatuses` matches the live values.

**Manual setup required:** create a public Supabase Storage bucket named `media` (see `AppConstants.storageBucket`) with folders `players/` and `news/`, or image uploads will fail.
