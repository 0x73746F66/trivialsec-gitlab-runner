ALTER TABLE accounts ADD COLUMN `is_active` TINYINT NOT NULL DEFAULT '0' AFTER is_setup;
ALTER TABLE plans ADD COLUMN `interval` VARCHAR(255) DEFAULT NULL AFTER currency;
ALTER TABLE plans CHANGE COLUMN currency currency VARCHAR(255) DEFAULT NULL;
ALTER TABLE plans CHANGE COLUMN cost cost decimal(10,2) UNSIGNED DEFAULT NULL;
CREATE TABLE IF NOT EXISTS plan_invoices (
    `plan_id` BIGINT UNSIGNED NOT NULL,
    `stripe_invoice_id` VARCHAR(255) DEFAULT NULL,
    `hosted_invoice_url` TEXT NOT NULL,
    `cost` DECIMAL(10,2) UNSIGNED DEFAULT NULL,
    `currency` VARCHAR(255) DEFAULT NULL,
    `interval` VARCHAR(255) DEFAULT NULL,
    `status` VARCHAR(255) DEFAULT NULL,
    `due_date` DATETIME DEFAULT NULL,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_plan_invoices PRIMARY KEY (plan_id)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
CREATE TABLE IF NOT EXISTS webhooks (
    `webhook_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `account_id` BIGINT UNSIGNED NOT NULL,
    `webhook_secret` VARCHAR(255) NOT NULL,
    `target` VARCHAR(255) NOT NULL,
    `comment` VARCHAR(255) DEFAULT NULL,
    `active` TINYINT NOT NULL DEFAULT '1',
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_webhooks PRIMARY KEY (webhook_id),
    INDEX index_webhooks_account_id (`account_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 ROW_FORMAT=FIXED;
