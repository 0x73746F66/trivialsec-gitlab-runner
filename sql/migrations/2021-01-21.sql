ALTER TABLE job_runs CHANGE COLUMN queue_data queue_data JSON NOT NULL;

CREATE INDEX index_plans_account_id ON plans (account_id);
CREATE INDEX index_plans_stripe_customer_id ON plans (stripe_customer_id);
CREATE INDEX index_members_account_id ON members (account_id);
CREATE INDEX index_members_email ON members (email);
CREATE INDEX index_api_keys_comment ON api_keys (`comment`);
CREATE INDEX index_invitations_account_id ON invitations (account_id);
CREATE INDEX index_invitations_confirmation_url ON invitations (confirmation_url);
CREATE INDEX index_invitations_email ON invitations (email);
CREATE INDEX index_subscribers_email ON subscribers (email);
CREATE INDEX index_activity_logs_member_id ON activity_logs (member_id);
CREATE INDEX index_notifications_account_id ON notifications (account_id);
CREATE INDEX index_links_slug ON links (slug);
CREATE INDEX index_domains_parent_domain_id ON domains (parent_domain_id);
CREATE INDEX index_domains_account_id ON domains (account_id);
CREATE INDEX index_domains_project_id ON domains (project_id);
CREATE INDEX index_domain_stats_domain_id ON domain_stats (domain_id);
CREATE INDEX index_domain_stats_stat ON domain_stats (domain_id, domain_stat);
CREATE INDEX index_findings_domain_id ON findings (domain_id);
CREATE INDEX index_findings_assignee_id ON findings (assignee_id);
CREATE INDEX index_finding_notes_finding_id ON finding_notes (finding_id);
CREATE INDEX index_service_types_name ON service_types (`name`);
CREATE INDEX index_dns_records_domain_id ON dns_records (domain_id);
CREATE INDEX index_programs_project_id ON programs (project_id);
CREATE INDEX index_known_ips_domain_id ON known_ips (domain_id);

ALTER TABLE accounts ROW_FORMAT=Fixed;
ALTER TABLE plans ROW_FORMAT=Fixed;
ALTER TABLE roles ROW_FORMAT=Fixed;
ALTER TABLE members ROW_FORMAT=Fixed;
ALTER TABLE api_keys ROW_FORMAT=Fixed;
ALTER TABLE members_roles ROW_FORMAT=Fixed;
ALTER TABLE subscribers ROW_FORMAT=Fixed;
ALTER TABLE activity_logs ROW_FORMAT=Fixed;
ALTER TABLE links ROW_FORMAT=Fixed;
ALTER TABLE projects ROW_FORMAT=Fixed;
ALTER TABLE domains ROW_FORMAT=Fixed;
ALTER TABLE finding_watchers ROW_FORMAT=Fixed;
ALTER TABLE service_types ROW_FORMAT=Fixed;
ALTER TABLE known_ips ROW_FORMAT=Fixed;
