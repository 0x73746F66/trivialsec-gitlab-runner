USE trivialsec;

ALTER TABLE invitations ADD COLUMN `role_id` bigint unsigned NOT NULL AFTER `member_id`;
ALTER TABLE invitations ADD COLUMN `confirmation_url` VARCHAR(255) NOT NULL AFTER `email`;
ALTER TABLE invitations ADD COLUMN `confirmation_sent` tinyint NOT NULL default '0' AFTER `confirmation_url`;
ALTER TABLE members ADD COLUMN `confirmation_url` VARCHAR(255) NOT NULL AFTER `verified`;
ALTER TABLE members ADD COLUMN `confirmation_sent` tinyint NOT NULL default '0' AFTER `confirmation_url`;
