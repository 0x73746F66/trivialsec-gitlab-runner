-- Account Configuration
select 
    a.alias as company_name,
    a.is_setup as account_setup,
    a.billing_email,
    a.verification_hash,
    a.registered as account_registered,
    p.name as plan_name,
    p.currency,
    p.cost,
    p.retention_days,
    p.is_dedicated,
    p.on_demand_passive_daily,
    p.on_demand_active_daily,
    p.domains_monitored,
    p.webhooks,
    p.threatintel,
    p.typosquatting as brand_protection,
    p.compromise_indicators,
    p.source_code_scans,
    p.compliance_reports,
    p.stripe_customer_id,
    p.stripe_product_id,
    p.stripe_price_id,
    p.stripe_payment_method_id,
    p.stripe_card_brand,
    p.stripe_card_last4,
    CONCAT(p.stripe_card_expiry_month, '/', p.stripe_card_expiry_year) as expiry,
    r.name as default_role,
    r.internal_only,
    c.blacklisted_domains,
    c.blacklisted_ips,
    c.nameservers,
    c.permit_domains
from accounts a
left join plans p on a.account_id = p.account_id
left join account_config c on a.account_id = c.account_id
left join roles r on c.default_role_id = r.role_id

-- Member details

select 
	m.email,
    a.alias as company_name,
    a.is_setup as account_setup,
    m.registered as member_registered,
    r.name as role_name,
    r.internal_only,
    a.billing_email,
	m.confirmation_url,
	m.confirmation_sent,
    a.verification_hash,
    a.registered as account_registered,
    p.name as plan_name,
    p.currency,
    p.cost,
    p.is_dedicated
from members_roles l
left join members m on l.member_id = m.member_id
left join roles r on l.role_id = r.role_id
left join accounts a on m.account_id = a.account_id
left join plans p on a.account_id = p.account_id

-- Invitations

select 
	i.email,
    a.alias as company_name,
    a.is_setup as account_setup,
    i.created_at,
    r.name as role_name,
    r.internal_only,
    a.billing_email,
	i.confirmation_url,
	i.confirmation_sent,
    i.message,
    i.deleted,
    m.email as invited_by,
    a.verification_hash,
    a.registered as account_registered,
    p.name as plan_name,
    p.currency,
    p.cost,
    p.is_dedicated
from invitations i
left join members m on i.member_id = m.member_id
left join roles r on i.role_id = r.role_id
left join accounts a on i.account_id = a.account_id
left join plans p on a.account_id = p.account_id
