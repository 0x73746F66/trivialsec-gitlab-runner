USE trivialsec;

ALTER TABLE account_config ADD COLUMN `cloudflare` VARCHAR(255) default NULL AFTER `chaos`;
ALTER TABLE account_config ADD COLUMN `recondev_free` VARCHAR(255) default NULL AFTER `securitytrails`;
ALTER TABLE account_config ADD COLUMN `recondev_paid` VARCHAR(255) default NULL AFTER `recondev_free`;
ALTER TABLE account_config ADD COLUMN `zoomeye` VARCHAR(255) default NULL AFTER `zetalytics`;
ALTER TABLE account_config CHANGE COLUMN github github_key VARCHAR(255) default null;
ALTER TABLE account_config ADD COLUMN `github_user` VARCHAR(255) default NULL AFTER `github_key`;
