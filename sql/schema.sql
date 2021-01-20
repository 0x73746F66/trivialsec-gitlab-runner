CREATE DATABASE IF NOT EXISTS trivialsec;
USE trivialsec;

CREATE TABLE IF NOT EXISTS accounts (
    `account_id` bigint unsigned not null auto_increment,
    `alias` VARCHAR(255) null,
    `socket_key` varchar(48) not null,
    `is_setup` tinyint not null default '0',
    `verification_hash` varchar(45) not null,
    `plan_id` bigint unsigned not null,
    `billing_email` VARCHAR(255) not null,
    `registered` TIMESTAMP not null default CURRENT_TIMESTAMP,
    constraint pk_accounts primary key (account_id)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS account_config (
    `account_id` bigint unsigned not null,
    `default_role_id` bigint unsigned default '3',
    `blacklisted_domains` TEXT default null,
    `blacklisted_ips` TEXT default null,
    `nameservers` TEXT default null,
    `permit_domains` TEXT default null,
    `github_key` VARCHAR(255) default null,
    `github_user` VARCHAR(255) default null,
    `gitlab` VARCHAR(255) default null,
    `alienvault` VARCHAR(255) default null,
    `binaryedge` VARCHAR(255) default null,
    `c99` VARCHAR(255) default null,
    `censys_key` VARCHAR(255) default null,
    `censys_secret` VARCHAR(255) default null,
    `chaos` VARCHAR(255) default null,
    `cloudflare`  VARCHAR(255) default null,
    `circl_user` VARCHAR(255) default null,
    `circl_pass` VARCHAR(255) default null,
    `dnsdb` VARCHAR(255) default null,
    `facebookct_key` VARCHAR(255) default null,
    `facebookct_secret` VARCHAR(255) default null,
    `networksdb` VARCHAR(255) default null,
    `passivetotal_key` VARCHAR(255) default null,
    `passivetotal_user` VARCHAR(255) default null,
    `securitytrails` VARCHAR(255) default null,
    `recondev_free` VARCHAR(255) default null,
    `recondev_paid` VARCHAR(255) default null,
    `shodan` VARCHAR(255) default null,
    `spyse` VARCHAR(255) default null,
    `twitter_key` VARCHAR(255) default null,
    `twitter_secret` VARCHAR(255) default null,
    `umbrella` VARCHAR(255) default null,
    `urlscan` VARCHAR(255) default null,
    `virustotal` VARCHAR(255) default null,
    `whoisxml` VARCHAR(255) default null,
    `zetalytics` VARCHAR(255) default null,
    `zoomeye` VARCHAR(255) default null,
    constraint pk_account_config primary key (account_id)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS plans (
    `plan_id` bigint unsigned not null auto_increment,
    `account_id` bigint unsigned not null,
    `name` VARCHAR(255) not null,
    `is_dedicated` tinyint not null default '0',
    `stripe_customer_id` VARCHAR(255) default null,
    `stripe_product_id` VARCHAR(255) default null,
    `stripe_price_id` VARCHAR(255) default null,
    `stripe_subscription_id` VARCHAR(255) default null,
    `stripe_payment_method_id` VARCHAR(255) default null,
    `stripe_card_brand` VARCHAR(255) default null,
    `stripe_card_last4` INT(4) default null,
    `stripe_card_expiry_month` INT(2) default null,
    `stripe_card_expiry_year` INT(4) default null,
    `cost` decimal(10,2) unsigned not null,
    `currency` VARCHAR(255) not null,
    `retention_days` int unsigned not null default '32',
    `active_daily` int not null default '1',
    `scheduled_active_daily` int not null default '0',
    `passive_daily` int not null default '10',
    `scheduled_passive_daily` int not null default '0',
    `git_integration_daily` int not null default '0',
    `source_code_daily` int not null default '0',
    `dependency_support_rating` int not null default '0',
    `alert_email` tinyint not null default '0',
    `alert_integrations` tinyint not null default '0',
    `threatintel` tinyint not null default '0',
    `compromise_indicators` tinyint not null default '0',
    `typosquatting` tinyint not null default '0',
    constraint pk_plan_limits primary key (plan_id)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS roles (
    `role_id` bigint unsigned not null auto_increment,
    `name` VARCHAR(255) not null,
    `internal_only` tinyint not null default '0',
    constraint pk_roles primary key (role_id)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS members (
    `member_id` bigint unsigned not null auto_increment,
    `email` VARCHAR(255) not null,
    `password` VARCHAR(255) not null,
    `account_id` bigint unsigned not null,
    `verified` tinyint not null default '0',
    `confirmation_url` VARCHAR(255) not null,
    `confirmation_sent` tinyint not null default '0',
    `registered` TIMESTAMP not null default CURRENT_TIMESTAMP,
    constraint pk_members primary key (member_id)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS api_keys (
    `api_key` VARCHAR(255) not null,
    `api_key_secret` VARCHAR(255) not null,
    `comment` VARCHAR(255) not null,
    `member_id` bigint unsigned not null,
    `allowed_origin` VARCHAR(255) not null,
    `active` tinyint not null default '0',
    `created_at` TIMESTAMP not null default CURRENT_TIMESTAMP,
    constraint pk_api_keys primary key (api_key)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS members_roles (
    `member_id` bigint unsigned not null,
    `role_id` bigint unsigned not null,
    constraint pk_members_roles primary key (role_id, member_id)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS invitations (
    `invitation_id` bigint unsigned not null auto_increment,
    `account_id` bigint unsigned not null,
    `invited_by_member_id` bigint unsigned not null,
    `member_id` bigint unsigned default null,
    `role_id` bigint unsigned not null,
    `message` TEXT default null,
    `email` VARCHAR(255) not null,
    `confirmation_url` VARCHAR(255) not null,
    `confirmation_sent` tinyint not null default '0',
    `deleted` tinyint not null default '0',
    `created_at` TIMESTAMP not null default CURRENT_TIMESTAMP,
    constraint pk_invitations primary key (invitation_id)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS subscribers (
    `subscriber_id` bigint unsigned not null auto_increment,
    `email` VARCHAR(255) not null,
    `deleted` tinyint not null default '0',
    `created_at` TIMESTAMP not null default CURRENT_TIMESTAMP,
    constraint pk_subscribers primary key (subscriber_id)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS activity_logs (
    `activity_log_id` bigint unsigned not null auto_increment,
    `member_id` bigint unsigned default null,
    `action` VARCHAR(255) not null,
    `description` VARCHAR(255) not null,
    `occurred` TIMESTAMP not null default CURRENT_TIMESTAMP,
    constraint pk_activity_logs primary key (activity_log_id)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS notifications (
    `notification_id` bigint unsigned not null auto_increment,
    `account_id` bigint unsigned not null,
    `description` text not null,
    `url` VARCHAR(255) default null,
    `marked_read` tinyint not null default '0',
    `read_by` datetime default null,
    `created_at` TIMESTAMP not null default CURRENT_TIMESTAMP,
    constraint pk_notifications primary key (notification_id)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS links (
    `link_id` bigint unsigned not null auto_increment,
    `campaign` VARCHAR(255) not null,
    `channel` VARCHAR(255) not null,
    `slug` VARCHAR(255) not null,
    `deleted` tinyint not null default '0',
    `expires` datetime not null,
    `created_at` TIMESTAMP not null default CURRENT_TIMESTAMP,
    constraint pk_links primary key (link_id)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS key_values (
    `key_value_id` bigint unsigned not null auto_increment,
    `type` VARCHAR(255) not null,
    `key` VARCHAR(255) not null,
    `value` text not null,
    `hidden` tinyint not null default '0',
    `active_date` datetime default null,
    `created_at` TIMESTAMP not null default CURRENT_TIMESTAMP,
    constraint pk_key_values primary key (key_value_id)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS projects (
    `project_id` bigint unsigned not null auto_increment,
    `account_id` bigint unsigned not null,
    `name` VARCHAR(255) not null,
    `created_at` TIMESTAMP not null default CURRENT_TIMESTAMP,
    `deleted` tinyint not null default '0',
    constraint pk_projects primary key (project_id)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS domains (
    `domain_id` bigint unsigned not null auto_increment,
    `parent_domain_id` bigint unsigned default null,
    `account_id` bigint unsigned not null,
    `project_id` bigint unsigned not null,
    `source` VARCHAR(255) not null,
    `name` VARCHAR(255) not null,
    `schedule` VARCHAR(255) default null,
    `enabled` tinyint not null default '0',
    `created_at`  TIMESTAMP not null default CURRENT_TIMESTAMP,
    `deleted` tinyint not null default '0',
    constraint pk_domains primary key (domain_id)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS domain_stats (
    `domain_stats_id` bigint unsigned not null auto_increment,
    `domain_id` bigint unsigned not null,
    `domain_stat` VARCHAR(255) not null,
    `domain_value` VARCHAR(255) default null,
    `domain_data` text default null,
    `created_at`  TIMESTAMP not null default CURRENT_TIMESTAMP,
    constraint pk_domain_stats primary key (domain_stats_id)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS findings (
    `finding_id` bigint unsigned not null auto_increment,
    `finding_detail_id` VARCHAR(255) not null,
    `account_id` bigint unsigned not null,
    `project_id` bigint unsigned not null,
    `domain_id` bigint unsigned default null,
    `assignee_id` bigint unsigned default null,
    `service_type_id` bigint unsigned not null,
    `source_description` TEXT not null,
    `is_passive` tinyint not null,
    `severity_normalized` int(4) not null default '0',
    `verification_state` VARCHAR(255) not null,
    `workflow_state` VARCHAR(255) not null,
    `state` VARCHAR(255) not null,
    `evidence` text default null,
    `created_at` TIMESTAMP not null default CURRENT_TIMESTAMP,
    `updated_at` datetime default null,
    `defer_to` datetime default null,
    `last_observed_at` datetime default null,
    `archived` tinyint not null default '0',
    constraint pk_findings primary key (finding_id)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS finding_details (
    `finding_detail_id` VARCHAR(255) not null,
    `title` VARCHAR(255) not null,
    `description` text default null,
    `type_namespace` VARCHAR(255) null default null,
    `type_category` VARCHAR(255) null default null,
    `type_classifier` VARCHAR(255) null default null,
    `criticality` int(4) not null default '0',
    `confidence` int(4) not null default '0',
    `severity_product` int(4) not null default '0',
    `recommendation` text default null,
    `recommendation_url` VARCHAR(255) default null,
    `cvss_vector` VARCHAR(255) default null,
    `created_at` TIMESTAMP not null default CURRENT_TIMESTAMP,
    `review` tinyint not null default '1',
    `updated_at` datetime default null,
    `modified_by_id` bigint unsigned default null,
    constraint pk_finding_details primary key (finding_detail_id)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS finding_watchers (
    `member_id` bigint unsigned not null,
    `finding_id` bigint unsigned not null,
    constraint pk_finding_watchers primary key (member_id, finding_id)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS finding_notes (
    `finding_note_id` bigint unsigned not null auto_increment,
    `finding_id` bigint unsigned not null,
    `member_id` bigint unsigned not null,
    `text` text not null,
    `updated_at` TIMESTAMP not null default CURRENT_TIMESTAMP,
    `deleted` tinyint not null default '0',
    constraint pk_finding_notes primary key (finding_note_id)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS service_types (
    `service_type_id` bigint unsigned not null auto_increment,
    `name` VARCHAR(255) not null,
    `category` VARCHAR(255) not null,
    constraint pk_service_types primary key (service_type_id)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS job_runs (
    `job_run_id` bigint unsigned not null auto_increment,
    `account_id` bigint unsigned not null,
    `project_id` bigint unsigned not null,
    `service_type_id` bigint unsigned not null,
    `node_id` VARCHAR(255) default null,
    `worker_id` VARCHAR(255) default null,
    `queue_data` TEXT not null,
    `state` VARCHAR(255) not null,
    `worker_message` TEXT default null,
    `priority` int(4) not null default 0,
    `created_at` TIMESTAMP not null default CURRENT_TIMESTAMP,
    `started_at` datetime default null,
    `updated_at` datetime default null,
    `completed_at` datetime default null,
    constraint pk_job_runs primary key (job_run_id)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS dns_records (
    `dns_record_id` bigint unsigned not null auto_increment,
    `domain_id` bigint unsigned not null,
    `ttl` int unsigned not null,
    `dns_class` VARCHAR(255) not null,
    `resource` VARCHAR(255) not null,
    `answer` text not null,
    `raw` text not null,
    `last_checked` TIMESTAMP not null default CURRENT_TIMESTAMP,
    constraint pk_dnsrecords primary key (dns_record_id)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS programs (
    `program_id` bigint unsigned not null auto_increment,
    `project_id` bigint unsigned not null,
    `domain_id` bigint unsigned default null,
    `name` VARCHAR(255) not null,
    `version` VARCHAR(255) default null,
    `source_description` text not null,
    `external_url` VARCHAR(255) default null,
    `icon_url` VARCHAR(255) default null,
    `category` VARCHAR(255) not null,
    `created_at` TIMESTAMP not null default CURRENT_TIMESTAMP,
    `last_checked` datetime default null,
    constraint pk_programs primary key (program_id)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS security_alerts (
    `security_alert_id` bigint unsigned not null auto_increment,
    `account_id` bigint unsigned not null,
    `type` VARCHAR(255) not null,
    `description` text not null,
    `hook_url` VARCHAR(255) default null,
    `delivered` tinyint not null default '0',
    `delivered_at` datetime default null,
    `created_at` TIMESTAMP not null default CURRENT_TIMESTAMP,
    constraint pk_security_alerts primary key (security_alert_id)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS known_ips (
    `known_ip_id` bigint unsigned not null auto_increment,
    `account_id` bigint unsigned not null,
    `project_id` bigint unsigned default null,
    `domain_id` bigint unsigned default null,
    `ip_address` VARCHAR(255) not null,
    `ip_version` varchar(4) not null,
    `source` VARCHAR(255) not null,
    `asn_code` int default null,
    `asn_name` VARCHAR(255) default null,
    `updated_at` TIMESTAMP not null default CURRENT_TIMESTAMP,
    constraint pk_knownips primary key (known_ip_id)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS feeds (
    `feed_id` bigint unsigned not null auto_increment,
    `name` VARCHAR(255) not null,
    `category` VARCHAR(255) not null,
    `description` text not null,
    `url` VARCHAR(255) not null,
    `method` VARCHAR(255) default 'http',
    `username` VARCHAR(255) default null,
    `credential_key` VARCHAR(255) default null,
    `http_code` int(3) default null,
    `http_status` VARCHAR(255) default null,
    `type` VARCHAR(255) not null,
    `alert_title` VARCHAR(255) default null,
    `schedule` VARCHAR(255) not null,
    `feed_site` VARCHAR(255) default null,
    `abuse_email` VARCHAR(255) default null,
    `disabled` tinyint not null default '0',
    `start_check` datetime default null,
    `last_checked` datetime default null,
    constraint pk_feeds primary key (feed_id)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
