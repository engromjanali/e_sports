# e_sports

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

# database :
CREATE TABLE public.season (
  id bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  name text,
  start_date timestamp with time zone NOT NULL DEFAULT now(),
  end_date timestamp with time zone,
  is_current boolean NOT NULL DEFAULT false,
  CONSTRAINT season_pkey PRIMARY KEY (id)
);
CREATE TABLE public.players (
  id uuid NOT NULL DEFAULT uuid_generate_v4(),
  name text NOT NULL,
  sort_name text,
  profileimageurl text,
  jerseynumber integer,
  playerroles ARRAY DEFAULT '{}'::text[],
  customtags ARRAY DEFAULT '{}'::text[],
  createdat timestamp with time zone DEFAULT now(),
  CONSTRAINT players_pkey PRIMARY KEY (id)
);
CREATE TABLE public.matches (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  season_id bigint NOT NULL,
  hometeam text NOT NULL DEFAULT 'The Elits'::text,
  awayteam text NOT NULL DEFAULT ''::text,
  homescore integer,
  awayscore integer,
  date text NOT NULL DEFAULT ''::text,
  competition text NOT NULL DEFAULT ''::text,
  status text NOT NULL DEFAULT 'upcoming'::text CHECK (status = ANY (ARRAY['upcoming'::text, 'live'::text, 'completed'::text, 'cancelled'::text])),
  CONSTRAINT matches_pkey PRIMARY KEY (id),
  CONSTRAINT matches_season_id_fkey FOREIGN KEY (season_id) REFERENCES public.season(id)
);
CREATE TABLE public.match_entries (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  playerid uuid NOT NULL,
  matchid uuid NOT NULL,
  goals integer DEFAULT 0,
  goalsconceded integer DEFAULT 0,
  hattricks integer DEFAULT 0,
  cleansheet boolean DEFAULT false,
  motm boolean DEFAULT false,
  result text DEFAULT 'draw'::text CHECK (result = ANY (ARRAY['win'::text, 'loss'::text, 'draw'::text])),
  notes text DEFAULT ''::text,
  source text DEFAULT 'manual'::text,
  CONSTRAINT match_entries_pkey PRIMARY KEY (id),
  CONSTRAINT match_entries_playerid_fkey FOREIGN KEY (playerid) REFERENCES public.players(id),
  CONSTRAINT match_entries_matchid_fkey FOREIGN KEY (matchid) REFERENCES public.matches(id)
);
CREATE TABLE public.player_season_stats (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  player_id uuid NOT NULL,
  season_id bigint NOT NULL,
  appearances integer DEFAULT 0,
  goals integer DEFAULT 0,
  assists integer DEFAULT 0,
  cleansheets integer DEFAULT 0,
  hattricks integer DEFAULT 0,
  motmcount integer DEFAULT 0,
  wins integer DEFAULT 0,
  draws integer DEFAULT 0,
  losses integer DEFAULT 0,
  goalsconceded integer DEFAULT 0,
  avgrating numeric DEFAULT 0.00,
  updated_at timestamp with time zone DEFAULT now(),
  CONSTRAINT player_season_stats_pkey PRIMARY KEY (id),
  CONSTRAINT player_season_stats_player_id_fkey FOREIGN KEY (player_id) REFERENCES public.players(id),
  CONSTRAINT player_season_stats_season_id_fkey FOREIGN KEY (season_id) REFERENCES public.season(id)
);
CREATE TABLE public.awards (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  player_id uuid NOT NULL,
  season_id bigint NOT NULL,
  award_type text NOT NULL CHECK (award_type = ANY (ARRAY['potw'::text, 'potm'::text, 'top_scorer'::text, 'season_mvp'::text, 'golden_glove'::text, 'custom'::text])),
  week integer CHECK (week >= 1 AND week <= 53),
  month integer CHECK (month >= 1 AND month <= 12),
  year integer NOT NULL,
  notes text,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT awards_pkey PRIMARY KEY (id),
  CONSTRAINT awards_player_id_fkey FOREIGN KEY (player_id) REFERENCES public.players(id),
  CONSTRAINT awards_season_id_fkey FOREIGN KEY (season_id) REFERENCES public.season(id)
);
CREATE TABLE public.news (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  created_at timestamp with time zone NOT NULL DEFAULT timezone('utc'::text, now()),
  title text NOT NULL,
  content text NOT NULL,
  author text NOT NULL,
  category text NOT NULL,
  date text NOT NULL,
  hot boolean NOT NULL DEFAULT false,
  image text,
  emoji text,
  CONSTRAINT news_pkey PRIMARY KEY (id)
);
CREATE TABLE public.app_settings (
  id bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  current_season_id bigint,
  version text,
  verify_email boolean NOT NULL DEFAULT false,
  maintenance_mode boolean NOT NULL DEFAULT false,
  updated_at timestamp with time zone DEFAULT now(),
  CONSTRAINT app_settings_pkey PRIMARY KEY (id),
  CONSTRAINT app_settings_current_season_id_fkey FOREIGN KEY (current_season_id) REFERENCES public.season(id)
);

match status {{live, upcoming, finished, cancelled, all}}
