USE trivialsec;
SET @dbname = DATABASE();

ALTER TABLE feeds ADD COLUMN method varchar(255) DEFAULT 'http' AFTER url;
ALTER TABLE feeds ADD COLUMN username varchar(255) DEFAULT NULL AFTER method;
ALTER TABLE feeds ADD COLUMN credential_key varchar(255) DEFAULT NULL AFTER username;
ALTER TABLE feeds ADD COLUMN http_code int(3) DEFAULT NULL AFTER credential_key;
ALTER TABLE feeds ADD COLUMN http_status varchar(255) DEFAULT NULL AFTER http_code;
