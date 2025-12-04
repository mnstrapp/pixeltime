CREATE TABLE IF NOT EXISTS layers (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  project_id TEXT NOT NULL,
  position INTEGER NOT NULL,
  visible BOOLEAN NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_layers_project_id ON layers (project_id);
CREATE INDEX IF NOT EXISTS idx_layers_position ON layers (position);
CREATE INDEX IF NOT EXISTS idx_layers_visible ON layers (visible);