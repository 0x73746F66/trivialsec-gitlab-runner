ALTER TABLE job_runs DROP COLUMN `tracking_id`;
ALTER TABLE projects DROP COLUMN `tracking_id`;
ALTER TABLE accounts CHANGE COLUMN verification_hash verification_hash VARCHAR(56) NOT NULL;