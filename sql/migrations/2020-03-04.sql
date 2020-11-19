USE trivialsec;
SET @dbname = DATABASE();

ALTER TABLE jobs ADD COLUMN service_name VARCHAR(255) NOT NULL DEFAULT 'default' AFTER job_name;
ALTER TABLE jobs ADD COLUMN service_category VARCHAR(255) NOT NULL DEFAULT 'default' AFTER service_name;
