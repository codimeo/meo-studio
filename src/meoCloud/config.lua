local config = require('lapis.config')

config({'development', 'staging', 'production', 'test'}, {
    postgres = {
        host = os.getenv('DATABASE_URL') or '127.0.0.1:5432',
        user = os.getenv('DATABASE_USERNAME') or 'cloud',
        password = os.getenv('DATABASE_PASSWORD') or 'snap-cloud-password',
        database = os.getenv('DATABASE_NAME') or 'snapcloud'
    },
    session_name = 'snapsession',

    -- Exception monitoring service.
    -- Leave empty to avoid forwarding errors.
    rollbar_token = os.getenv('ROLLBAR_TOKEN'),

    -- Change to the relative (or absolute) path of your disk storage
    -- directory.  Note that the user running Lapis needs to have
    -- read & write permissions to that path.
    store_path = os.getenv('PROJECT_STORAGE_PATH') or 'store',

    -- for sending email
    mail_user = os.getenv('MAIL_SMTP_USER') or 'cloud',
    mail_password = os.getenv('MAIL_SMTP_PASSWORD') or 'cloudemail',
    mail_server = os.getenv('MAIL_SMTP_SERVER') or '127.0.0.1',
    mail_from_name = "MeoCloud",
    mail_from = "noreply@meo.codimeo.com",
    mail_footer = "<br/><br/><p><small>Please do not reply to this email. This message was automatically generated by the Snap!Cloud. To contact an actual human being, please write to <a href='mailto:contact@upgrade-code.org'>contact@upgrade-code.org</a></small></p>",

    discourse_sso_secret = os.getenv('DISCOURSE_SSO_SECRET'),
    worker_connections = os.getenv('WORKER_CONNECTIONS') or 1024,

    hostname = os.getenv('HOSTNAME') or 'localhost',
    secondary_hostname = os.getenv('SECONDARY_HOSTNAME') or 'localhost',
    maintenance_mode = os.getenv('MAINTENANCE_MODE') or 'false'
})

print(config.mail_user)

config({'development', 'test'}, {
    use_daemon = 'off',
    site_name = 'dev | MeoCloud',
    port = os.getenv('PORT') or 8080,
    mail_smtp_port = os.getenv('MAIL_SMTP_PORT') or 1025,
    dns_resolver = '8.8.8.8',
    code_cache = 'off',
    num_workers = 1,
    log_directive = 'stderr notice',
    logging = {
        queries = true,
        requests = true
    },
    secret = os.getenv('SESSION_SECRET_BASE') or 'this is a secret',
    measure_performance = true,

    -- development needs no special SSL or cert config.
    primary_nginx_config = 'locations.conf',
    -- empty string when no additional configs are included.
    secondary_nginx_config = ''
})

config({'test'}, {
    postgres = {
        database = 'snapcloud_test'
    },
    store_path = 'store/test',
    logging = {
        queries = false,
        locations = false
    }
})

config({'production', 'staging'}, {
    use_daemon = os.getenv('DAEMON') or 'on',
    port = os.getenv('PORT') or 80,
    mail_smtp_port = 587,
    dns_resolver = '173.245.58.51 ipv6=off',

    secret = os.getenv('SESSION_SECRET_BASE'),
    code_cache = 'on',
    
    log_directive = 'stderr notice',
    logging = {
        queries = false,
        requests = true
    },

--    log_directive = 'logs/error.log error',

    -- TODO: See if we can turn this on without a big hit
    measure_performance = false
})

config('production', {
    site_name = 'MeoCloud',
    num_workers = 1,
    primary_nginx_config = 'http-only.conf',
--  secondary_nginx_config = 'include nginx.conf.d/ssl-production.conf;'
    -- ssl not needed here because the connection is proxied with regular
    -- nginx
    secondary_nginx_config = ''
})

config('staging', {
    site_name = 'staging | Snap Cloud',
    -- the staging server is a low-cpu server.
    num_workers = 1,
    primary_nginx_config = 'http-only.conf',
--  secondary_nginx_config = 'include nginx.conf.d/ssl-staging.conf;'
    -- ssl not needed here because the connection is proxied with regular
    -- nginx
    secondary_nginx_config = ''
})
