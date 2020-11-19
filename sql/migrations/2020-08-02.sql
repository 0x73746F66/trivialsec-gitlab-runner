USE trivialsec;

DROP TABLE jobs;
DROP TABLE services;
DROP TABLE plans;
DROP TABLE plan_limits;

CREATE TABLE IF NOT EXISTS plans (
    `plan_id` bigint unsigned not null auto_increment,
    `account_id` bigint unsigned not null,
    `name` VARCHAR(255) not null,
    `is_dedicated` tinyint not null default '0',
    `cost` decimal(10,2) unsigned not null,
    `currency` VARCHAR(255) not null,
    `retention_days` int unsigned not null default '32',
    `active_daily` int not null default '1',
    `scheduled_active_daily` int not null default '1',
    `passive_daily` int not null default '1',
    `scheduled_passive_daily` int not null default '1',
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

INSERT INTO plans (
    `plan_id`, `account_id`, `name`, `is_dedicated`, `cost`, `currency`, `retention_days`,
    `active_daily`, `scheduled_active_daily`, `passive_daily`, `scheduled_passive_daily`,
    `git_integration_daily`, `source_code_daily`, `dependency_support_rating`,
    `alert_email`, `alert_integrations`,
    `threatintel`, `compromise_indicators`, `typosquatting`
    ) VALUES (
    1, 1, 'Internal', 0, 0, 'AUD', 1825,
    999999, 999999, 999999, 999999,
    999999, 999999, 999999,
    1, 1,
    1, 1, 1
    );

CREATE TABLE IF NOT EXISTS service_types (
    `type_id` bigint unsigned not null auto_increment,
    `name` VARCHAR(255) not null,
    `category` VARCHAR(255) not null,
    constraint pk_service_types primary key (type_id)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS services (
    `node_id` VARCHAR(255) not null,
    `account_id` bigint unsigned default null,
    `type_id` bigint unsigned not null,
    `state` VARCHAR(255) not null,
    `created_at` TIMESTAMP not null default CURRENT_TIMESTAMP,
    `updated_at` datetime default null,
    constraint pk_services primary key (node_id)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS workers (
    `worker_id` VARCHAR(255) not null,
    `account_id` bigint unsigned default null,
    `node_id` VARCHAR(255) not null,
    `type_id` bigint unsigned not null,
    `started_at` TIMESTAMP not null default CURRENT_TIMESTAMP,
    constraint pk_workers primary key (worker_id)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS account_config (
    `account_id` bigint unsigned not null,
    `blacklisted_domains` TEXT default null,
    `blacklisted_ips` TEXT default null,
    `nameservers` TEXT default null,
    `alienvault` VARCHAR(255) default null,
    `binaryedge` VARCHAR(255) default null,
    `c99` VARCHAR(255) default null,
    `censys_key` VARCHAR(255) default null,
    `censys_secret` VARCHAR(255) default null,
    `chaos` VARCHAR(255) default null,
    `circl_user` VARCHAR(255) default null,
    `circl_pass` VARCHAR(255) default null,
    `dnsdb` VARCHAR(255) default null,
    `facebookct_key` VARCHAR(255) default null,
    `facebookct_secret` VARCHAR(255) default null,
    `github` VARCHAR(255) default null,
    `networksdb` VARCHAR(255) default null,
    `passivetotal_key` VARCHAR(255) default null,
    `passivetotal_user` VARCHAR(255) default null,
    `securitytrails` VARCHAR(255) default null,
    `shodan` VARCHAR(255) default null,
    `spyse` VARCHAR(255) default null,
    `twitter_key` VARCHAR(255) default null,
    `twitter_secret` VARCHAR(255) default null,
    `umbrella` VARCHAR(255) default null,
    `urlscan` VARCHAR(255) default null,
    `virustotal` VARCHAR(255) default null,
    `whoisxml` VARCHAR(255) default null,
    `zetalytics` VARCHAR(255) default null,
    constraint pk_account_config primary key (account_id)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS job_runs (
    `job_run_id` bigint unsigned not null auto_increment,
    `account_id` bigint unsigned not null,
    `project_id` bigint unsigned not null,
    `tracking_id` VARCHAR(255) not null,
    `queue_data` TEXT default null,
    `state` VARCHAR(255) not null,
    `worker_message` TEXT default null,
    `priority` int(4) not null default 0,
    `created_at` TIMESTAMP not null default CURRENT_TIMESTAMP,
    `started_at` datetime default null,
    `completed_at` datetime default null,
    constraint pk_job_runs primary key (job_run_id)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

INSERT INTO service_types ( `name`, `category` ) VALUES ( 'spect', 'fingerprinting');
INSERT INTO service_types ( `name`, `category` ) VALUES ( 'amass', 'subdomains');
INSERT INTO service_types ( `name`, `category` ) VALUES ( 'nmap', 'network');
INSERT INTO service_types ( `name`, `category` ) VALUES ( 'testssl', 'dast');
INSERT INTO service_types ( `name`, `category` ) VALUES ( 'splash', 'crawler');
INSERT INTO service_types ( `name`, `category` ) VALUES ( 'nikto2', 'dast');
INSERT INTO service_types ( `name`, `category` ) VALUES ( 'zap', 'dast');
INSERT INTO service_types ( `name`, `category` ) VALUES ( 'dependency-check', 'sca');
INSERT INTO service_types ( `name`, `category` ) VALUES ( 'drill', 'fingerprinting');
INSERT INTO service_types ( `name`, `category` ) VALUES ( 'retirejs', 'sca');
INSERT INTO service_types ( `name`, `category` ) VALUES ( 'git-secrets', 'secrets');
INSERT INTO service_types ( `name`, `category` ) VALUES ( 'exposed-repos', 'secrets');
INSERT INTO service_types ( `name`, `category` ) VALUES ( 'dsstore', 'secrets');
INSERT INTO service_types ( `name`, `category` ) VALUES ( 'phonito', 'sast');
