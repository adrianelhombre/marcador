-- Ejecuta esto en Supabase → SQL Editor

-- Tabla principal del marcador
create table if not exists marcador_estado (
  id        integer primary key default 1,
  estado    jsonb not null default '{}'::jsonb,
  updated_at timestamptz default now()
);

-- Solo puede haber una fila (id=1)
insert into marcador_estado (id, estado) values (1, '{
  "mode": 1,
  "m1": {
    "active": true,
    "local": "LOCAL",
    "visitor": "VISITANTE",
    "gl": 0,
    "gv": 0,
    "elapsed": 0,
    "elapsedAtPause": 0,
    "startedAt": null,
    "running": false,
    "duration": 45,
    "half": 1,
    "shieldLocal": null,
    "shieldVisitor": null
  },
  "m2": null
}'::jsonb)
on conflict (id) do nothing;

-- Habilitar Realtime en esta tabla
alter publication supabase_realtime add table marcador_estado;

-- Política RLS: lectura y escritura pública (es una app local, no necesitamos auth)
alter table marcador_estado enable row level security;

create policy "public read"  on marcador_estado for select using (true);
create policy "public write" on marcador_estado for update using (true);
