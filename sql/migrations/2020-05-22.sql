USE trivialsec;
SET @dbname = DATABASE();

ALTER TABLE accounts CHANGE COLUMN api_key socket_key varchar(48) not null;
ALTER TABLE accounts ADD COLUMN verification_hash VARCHAR(45) DEFAULT NULL AFTER socket_key;
ALTER TABLE domains DROP COLUMN verification_hash;
