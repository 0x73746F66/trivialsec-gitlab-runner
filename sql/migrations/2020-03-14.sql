USE trivialsec;
SET @dbname = DATABASE();

ALTER TABLE findings ADD COLUMN defer_to DATETIME DEFAULT NULL AFTER updated_at;
