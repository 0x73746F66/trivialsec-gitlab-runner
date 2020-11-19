ALTER TABLE invitations ADD COLUMN `invited_by_member_id` BIGINT unsigned NOT NULL AFTER `account_id`;
ALTER TABLE invitations CHANGE COLUMN `member_id` `member_id` bigint unsigned default null;
ALTER TABLE invitations CHANGE COLUMN `message` `message` TEXT default null;
