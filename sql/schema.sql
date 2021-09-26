CREATE DATABASE IF NOT EXISTS trivialsec;
USE trivialsec;
SET time_zone = '+00:00';

CREATE TABLE IF NOT EXISTS accounts (
    `account_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `alias` VARCHAR(255) NULL,
    `socket_key` VARCHAR(48) NOT NULL,
    `is_setup` TINYINT NOT NULL DEFAULT '0',
    `verification_hash` VARCHAR(56) NOT NULL,
    `billing_email` VARCHAR(255) NOT NULL,
    `registered` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_accounts PRIMARY KEY (account_id)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 ROW_FORMAT=FIXED;

CREATE TABLE IF NOT EXISTS account_config (
    `account_id` BIGINT UNSIGNED NOT NULL,
    `default_role_id` BIGINT UNSIGNED DEFAULT '3',
    `blacklisted_domains` TEXT DEFAULT NULL,
    `blacklisted_ips` TEXT DEFAULT NULL,
    `nameservers` TEXT DEFAULT NULL,
    `permit_domains` TEXT DEFAULT NULL,
    `github_key` VARCHAR(255) DEFAULT NULL,
    `github_user` VARCHAR(255) DEFAULT NULL,
    `gitlab` VARCHAR(255) DEFAULT NULL,
    `alienvault` VARCHAR(255) DEFAULT NULL,
    `binaryedge` VARCHAR(255) DEFAULT NULL,
    `c99` VARCHAR(255) DEFAULT NULL,
    `censys_key` VARCHAR(255) DEFAULT NULL,
    `censys_secret` VARCHAR(255) DEFAULT NULL,
    `chaos` VARCHAR(255) DEFAULT NULL,
    `cloudflare`  VARCHAR(255) DEFAULT NULL,
    `circl_user` VARCHAR(255) DEFAULT NULL,
    `circl_pass` VARCHAR(255) DEFAULT NULL,
    `dnsdb` VARCHAR(255) DEFAULT NULL,
    `facebookct_key` VARCHAR(255) DEFAULT NULL,
    `facebookct_secret` VARCHAR(255) DEFAULT NULL,
    `networksdb` VARCHAR(255) DEFAULT NULL,
    `passivetotal_key` VARCHAR(255) DEFAULT NULL,
    `passivetotal_user` VARCHAR(255) DEFAULT NULL,
    `securitytrails` VARCHAR(255) DEFAULT NULL,
    `recondev_free` VARCHAR(255) DEFAULT NULL,
    `recondev_paid` VARCHAR(255) DEFAULT NULL,
    `shodan` VARCHAR(255) DEFAULT NULL,
    `spyse` VARCHAR(255) DEFAULT NULL,
    `twitter_key` VARCHAR(255) DEFAULT NULL,
    `twitter_secret` VARCHAR(255) DEFAULT NULL,
    `umbrella` VARCHAR(255) DEFAULT NULL,
    `urlscan` VARCHAR(255) DEFAULT NULL,
    `virustotal` VARCHAR(255) DEFAULT NULL,
    `whoisxml` VARCHAR(255) DEFAULT NULL,
    `zetalytics` VARCHAR(255) DEFAULT NULL,
    `zoomeye` VARCHAR(255) DEFAULT NULL,
    CONSTRAINT pk_account_config PRIMARY KEY (account_id)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS plans (
    `plan_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `account_id` BIGINT UNSIGNED NOT NULL,
    `name` VARCHAR(255) NOT NULL,
    `is_dedicated` TINYINT NOT NULL DEFAULT '0',
    `stripe_customer_id` VARCHAR(255) DEFAULT NULL,
    `stripe_product_id` VARCHAR(255) DEFAULT NULL,
    `stripe_price_id` VARCHAR(255) DEFAULT NULL,
    `stripe_subscription_id` VARCHAR(255) DEFAULT NULL,
    `stripe_payment_method_id` VARCHAR(255) DEFAULT NULL,
    `stripe_card_brand` VARCHAR(255) DEFAULT NULL,
    `stripe_card_last4` INT(4) DEFAULT NULL,
    `stripe_card_expiry_month` INT(2) DEFAULT NULL,
    `stripe_card_expiry_year` INT(4) DEFAULT NULL,
    `cost` DECIMAL(10,2) UNSIGNED DEFAULT NULL,
    `currency` VARCHAR(255) DEFAULT NULL,
    `interval` VARCHAR(255) DEFAULT NULL,
    `retention_days` int UNSIGNED NOT NULL DEFAULT '32',
    `on_demand_passive_daily` int NOT NULL DEFAULT '10',
    `on_demand_active_daily` int NOT NULL DEFAULT '1',
    `domains_monitored` int NOT NULL DEFAULT '1',
    `webhooks` TINYINT NOT NULL DEFAULT '0',
    `threatintel` TINYINT NOT NULL DEFAULT '0',
    `typosquatting` TINYINT NOT NULL DEFAULT '0',
    `compromise_indicators` TINYINT NOT NULL DEFAULT '0',
    `source_code_scans` TINYINT NOT NULL DEFAULT '0',
    `compliance_reports` TINYINT NOT NULL DEFAULT '0',
    CONSTRAINT pk_plans PRIMARY KEY (plan_id),
    INDEX index_plans_account_id (account_id),
    INDEX index_plans_stripe_customer_id (stripe_customer_id)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 ROW_FORMAT=FIXED;

CREATE TABLE IF NOT EXISTS plan_invoices (
    `stripe_invoice_id` VARCHAR(255) NOT NULL,
    `plan_id` BIGINT UNSIGNED NOT NULL,
    `hosted_invoice_url` TEXT DEFAULT NULL,
    `cost` DECIMAL(10,2) UNSIGNED DEFAULT NULL,
    `currency` VARCHAR(255) DEFAULT NULL,
    `coupon_code` VARCHAR(16) DEFAULT NULL,
    `coupon_desc` VARCHAR(255) DEFAULT NULL,
    `stripe_promotion_id` VARCHAR(255) DEFAULT NULL,
    `interval` VARCHAR(255) DEFAULT NULL,
    `status` VARCHAR(255) DEFAULT NULL,
    `due_date` DATETIME DEFAULT NULL,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_plan_invoices PRIMARY KEY (stripe_invoice_id)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS roles (
    `role_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(255) NOT NULL,
    `internal_only` TINYINT NOT NULL DEFAULT '0',
    CONSTRAINT pk_roles PRIMARY KEY (role_id)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 ROW_FORMAT=FIXED;

CREATE TABLE IF NOT EXISTS members (
    `member_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `email` VARCHAR(255) NOT NULL,
    `scratch_code` VARCHAR(255) DEFAULT NULL,
    `account_id` BIGINT UNSIGNED NOT NULL,
    `verified` TINYINT NOT NULL DEFAULT '0',
    `confirmation_url` VARCHAR(255) DEFAULT NULL,
    `confirmation_sent` TINYINT NOT NULL DEFAULT '0',
    `registered` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_members PRIMARY KEY (member_id),
    INDEX index_members_account_id (account_id),
    INDEX index_members_email (email)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 ROW_FORMAT=FIXED;

CREATE TABLE IF NOT EXISTS api_keys (
    `api_key` VARCHAR(255) NOT NULL,
    `api_key_secret` VARCHAR(255) NOT NULL,
    `comment` VARCHAR(255) NOT NULL,
    `member_id` BIGINT UNSIGNED NOT NULL,
    `active` TINYINT NOT NULL DEFAULT '0',
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_api_keys PRIMARY KEY (api_key),
    INDEX index_api_keys_comment (`comment`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 ROW_FORMAT=FIXED;

CREATE TABLE IF NOT EXISTS member_mfa (
    `mfa_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `member_id` BIGINT UNSIGNED NOT NULL,
    `type` VARCHAR(16) NOT NULL,
    `name` VARCHAR(255) DEFAULT NULL,
    `active` TINYINT NOT NULL DEFAULT '0',
    `totp_code` VARCHAR(32) DEFAULT NULL,
    `webauthn_id` TEXT DEFAULT NULL,
    `webauthn_public_key` TEXT DEFAULT NULL,
    `webauthn_challenge` VARCHAR(255) DEFAULT NULL,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    INDEX index_member_mfa_member_id_type (`member_id`, `type`),
    CONSTRAINT pk_member_mfa PRIMARY KEY (mfa_id)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 ROW_FORMAT=FIXED;

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

CREATE TABLE IF NOT EXISTS members_roles (
    `member_id` BIGINT UNSIGNED NOT NULL,
    `role_id` BIGINT UNSIGNED NOT NULL,
    CONSTRAINT pk_members_roles PRIMARY KEY (role_id, member_id)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 ROW_FORMAT=FIXED;

CREATE TABLE IF NOT EXISTS invitations (
    `invitation_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `account_id` BIGINT UNSIGNED NOT NULL,
    `invited_by_member_id` BIGINT UNSIGNED DEFAULT NULL,
    `member_id` BIGINT UNSIGNED DEFAULT NULL,
    `role_id` BIGINT UNSIGNED NOT NULL,
    `message` TEXT DEFAULT NULL,
    `email` VARCHAR(255) NOT NULL,
    `confirmation_url` VARCHAR(255) NOT NULL,
    `confirmation_sent` TINYINT NOT NULL DEFAULT '0',
    `deleted` TINYINT NOT NULL DEFAULT '0',
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_invitations PRIMARY KEY (invitation_id),
    INDEX index_invitations_account_id (account_id),
    INDEX index_invitations_confirmation_url (confirmation_url),
    INDEX index_invitations_email (email)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS activity_logs (
    `activity_log_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `member_id` BIGINT UNSIGNED DEFAULT NULL,
    `action` VARCHAR(255) NOT NULL,
    `description` VARCHAR(255) NOT NULL,
    `occurred` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_activity_logs PRIMARY KEY (activity_log_id),
    INDEX index_activity_logs_member_id (member_id)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 ROW_FORMAT=FIXED;

CREATE TABLE IF NOT EXISTS notifications (
    `notification_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `account_id` BIGINT UNSIGNED NOT NULL,
    `description` TEXT NOT NULL,
    `url` VARCHAR(255) DEFAULT NULL,
    `marked_read` TINYINT NOT NULL DEFAULT '0',
    `read_by` DATETIME DEFAULT NULL,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_notifications PRIMARY KEY (notification_id),
    INDEX index_notifications_account_id (account_id)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS links (
    `link_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `campaign` VARCHAR(255) NOT NULL,
    `channel` VARCHAR(255) NOT NULL,
    `slug` VARCHAR(255) NOT NULL,
    `deleted` TINYINT NOT NULL DEFAULT '0',
    `expires` DATETIME NOT NULL,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_links PRIMARY KEY (link_id),
    INDEX index_links_slug (slug)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 ROW_FORMAT=FIXED;

CREATE TABLE IF NOT EXISTS key_values (
    `key_value_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `type` VARCHAR(255) NOT NULL,
    `key` VARCHAR(255) NOT NULL,
    `value` TEXT NOT NULL,
    `hidden` TINYINT NOT NULL DEFAULT '0',
    `active_date` DATETIME DEFAULT NULL,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_key_values PRIMARY KEY (key_value_id)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS projects (
    `project_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `account_id` BIGINT UNSIGNED NOT NULL,
    `canonical_id` VARCHAR(255) NOT NULL,
    `name` VARCHAR(255) NOT NULL,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `deleted` TINYINT NOT NULL DEFAULT '0',
    CONSTRAINT pk_projects PRIMARY KEY (project_id)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 ROW_FORMAT=FIXED;

CREATE TABLE IF NOT EXISTS domain_monitoring (
    `domain_monitoring_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `domain_name` VARCHAR(255) NOT NULL,
    `account_id` BIGINT UNSIGNED NOT NULL,
    `project_id` BIGINT UNSIGNED NOT NULL,
    `schedule` VARCHAR(255) DEFAULT NULL,
    `enabled` TINYINT NOT NULL DEFAULT '0',
    `created_at`  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_domain_monitoring PRIMARY KEY (domain_monitoring_id),
    INDEX index_domain_monitoring_domain_name (domain_name),
    INDEX index_domain_monitoring_account_id (account_id),
    INDEX index_domain_monitoring_project_id (project_id)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 ROW_FORMAT=FIXED;

CREATE TABLE IF NOT EXISTS findings (
    `finding_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `finding_detail_id` VARCHAR(255) NOT NULL,
    `account_id` BIGINT UNSIGNED NOT NULL,
    `project_id` BIGINT UNSIGNED NOT NULL,
    `domain_id` BIGINT UNSIGNED DEFAULT NULL,
    `assignee_id` BIGINT UNSIGNED DEFAULT NULL,
    `service_type_id` BIGINT UNSIGNED NOT NULL,
    `source_description` TEXT NOT NULL,
    `is_passive` TINYINT NOT NULL,
    `cvss_vector` VARCHAR(255) DEFAULT NULL,
    `severity_normalized` INT(4) NOT NULL DEFAULT '0',
    `confidence` INT(4) NOT NULL DEFAULT '0',
    `verification_state` VARCHAR(255) NOT NULL,
    `workflow_state` VARCHAR(255) NOT NULL,
    `state` VARCHAR(255) NOT NULL,
    `evidence` TEXT DEFAULT NULL,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` DATETIME DEFAULT NULL,
    `defer_to` DATETIME DEFAULT NULL,
    `last_observed_at` DATETIME DEFAULT NULL,
    `archived` TINYINT NOT NULL DEFAULT '0',
    CONSTRAINT pk_findings PRIMARY KEY (finding_id),
    INDEX index_findings_domain_id (domain_id),
    INDEX index_findings_assignee_id (assignee_id)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS finding_details (
    `finding_detail_id` VARCHAR(255) NOT NULL,
    `title` VARCHAR(255) NOT NULL,
    `description` TEXT DEFAULT NULL,
    `type_namespace` VARCHAR(255) NULL DEFAULT NULL,
    `type_category` VARCHAR(255) NULL DEFAULT NULL,
    `type_classifier` VARCHAR(255) NULL DEFAULT NULL,
    `severity_product` INT(4) NOT NULL DEFAULT '0',
    `recommendation` TEXT DEFAULT NULL,
    `recommendation_url` VARCHAR(255) DEFAULT NULL,
    `cvss_vector` VARCHAR(255) DEFAULT NULL,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `review` TINYINT NOT NULL DEFAULT '1',
    `updated_at` DATETIME DEFAULT NULL,
    `modified_by_id` BIGINT UNSIGNED DEFAULT NULL,
    CONSTRAINT pk_finding_details PRIMARY KEY (finding_detail_id)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS finding_watchers (
    `member_id` BIGINT UNSIGNED NOT NULL,
    `finding_id` BIGINT UNSIGNED NOT NULL,
    CONSTRAINT pk_finding_watchers PRIMARY KEY (member_id, finding_id)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 ROW_FORMAT=FIXED;

CREATE TABLE IF NOT EXISTS finding_notes (
    `finding_note_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `finding_id` BIGINT UNSIGNED NOT NULL,
    `member_id` BIGINT UNSIGNED NOT NULL,
    `text` TEXT NOT NULL,
    `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `deleted` TINYINT NOT NULL DEFAULT '0',
    CONSTRAINT pk_finding_notes PRIMARY KEY (finding_note_id),
    INDEX index_finding_notes_finding_id (finding_id)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS service_types (
    `service_type_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(255) NOT NULL,
    `category` VARCHAR(255) NOT NULL,
    CONSTRAINT pk_service_types PRIMARY KEY (service_type_id),
    INDEX index_service_types_name (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 ROW_FORMAT=FIXED;

CREATE TABLE IF NOT EXISTS job_runs (
    `job_run_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `account_id` BIGINT UNSIGNED NOT NULL,
    `project_id` BIGINT UNSIGNED NOT NULL,
    `state` VARCHAR(255) NOT NULL,
    `worker_message` TEXT DEFAULT NULL,
    `service_type_id` BIGINT UNSIGNED NOT NULL,
    `node_id` VARCHAR(255) DEFAULT NULL,
    `worker_id` VARCHAR(255) DEFAULT NULL,
    `priority` INT(4) NOT NULL DEFAULT 0,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `started_at` DATETIME DEFAULT NULL,
    `updated_at` DATETIME DEFAULT NULL,
    `completed_at` DATETIME DEFAULT NULL,
    `queue_data` JSON NOT NULL,
    CONSTRAINT pk_job_runs PRIMARY KEY (job_run_id)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS security_alerts (
    `security_alert_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `account_id` BIGINT UNSIGNED NOT NULL,
    `type` VARCHAR(255) NOT NULL,
    `description` TEXT NOT NULL,
    `hook_url` VARCHAR(255) DEFAULT NULL,
    `delivered` TINYINT NOT NULL DEFAULT '0',
    `delivered_at` DATETIME DEFAULT NULL,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_security_alerts PRIMARY KEY (security_alert_id)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS feeds (
    `feed_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(255) NOT NULL,
    `category` VARCHAR(255) NOT NULL,
    `description` TEXT NOT NULL,
    `url` VARCHAR(255) NOT NULL,
    `method` VARCHAR(255) DEFAULT 'http',
    `username` VARCHAR(255) DEFAULT NULL,
    `credential_key` VARCHAR(255) DEFAULT NULL,
    `http_code` INT(3) DEFAULT NULL,
    `http_status` VARCHAR(255) DEFAULT NULL,
    `type` VARCHAR(255) NOT NULL,
    `alert_title` VARCHAR(255) DEFAULT NULL,
    `schedule` VARCHAR(255) NOT NULL,
    `feed_site` VARCHAR(255) DEFAULT NULL,
    `abuse_email` VARCHAR(255) DEFAULT NULL,
    `disabled` TINYINT NOT NULL DEFAULT '0',
    `start_check` DATETIME DEFAULT NULL,
    `last_checked` DATETIME DEFAULT NULL,
    CONSTRAINT pk_feeds PRIMARY KEY (feed_id)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
