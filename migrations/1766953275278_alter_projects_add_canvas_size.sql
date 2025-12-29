ALTER TABLE projects ADD COLUMN width INTEGER DEFAULT 100;
ALTER TABLE projects ADD COLUMN height INTEGER DEFAULT 100;

CREATE INDEX IF NOT EXISTS idx_projects_width ON projects (width);
CREATE INDEX IF NOT EXISTS idx_projects_height ON projects (height);