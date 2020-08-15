CREATE EXTENSION IF NOT EXISTS "pgcrypto";

CREATE OR REPLACE FUNCTION trigger_set_update_time() RETURNS TRIGGER AS $$
BEGIN
    NEW.update_time = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    username VARCHAR(255) NOT NULL UNIQUE,
    full_name VARCHAR(255),
    -- Max worldwide phone number format: \+[\d]{15}\-[\d]{11}
    phone_number VARCHAR(28),
    password_hash CHAR(60) NOT NULL,
    primary_email_id UUID UNIQUE,
    bio TEXT,
    location VARCHAR(255),
    create_time TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    update_time TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TRIGGER on_update_users BEFORE UPDATE ON users
FOR EACH ROW EXECUTE PROCEDURE trigger_set_update_time();

CREATE TABLE IF NOT EXISTS emails (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID DEFAULT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    create_time TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    update_time TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id)
        REFERENCES users (id)
        ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TRIGGER on_update_emails BEFORE UPDATE ON emails
FOR EACH ROW EXECUTE PROCEDURE trigger_set_update_time();

ALTER TABLE users
ADD FOREIGN KEY (primary_email_id)
    REFERENCES emails(id)
    ON DELETE RESTRICT ON UPDATE CASCADE;

CREATE TABLE IF NOT EXISTS links (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL,
    link_url VARCHAR(255),
    type INTEGER,
    create_time TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    update_time TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id)
        REFERENCES users (id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TRIGGER on_update_links BEFORE UPDATE ON links
FOR EACH ROW EXECUTE PROCEDURE trigger_set_update_time();

CREATE TABLE IF NOT EXISTS tokens (
    email VARCHAR(255) PRIMARY KEY,
    token VARCHAR(6) NOT NULL,
    expiration TIMESTAMP WITH TIME ZONE NOT NULL
);

CREATE TYPE Readiness AS ENUM ('READY', 'UNDERWAY', 'FAILURE', 'UNSUPPORTED');

CREATE TABLE IF NOT EXISTS projects (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    project_name VARCHAR(255) NOT NULL,
    git_url VARCHAR(255) NOT NULL UNIQUE,
    website VARCHAR(255),
    languages JSON,
    num_commits INTEGER DEFAULT 0,
    num_contributors INTEGER DEFAULT 0,
    star_rank FLOAT,
    dev_curve BYTEA,
    readiness Readiness NOT NULL,
    last_sync_time TIMESTAMP WITH TIME ZONE NOT NULL,
    create_time TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    update_time TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TRIGGER on_update_projects BEFORE UPDATE ON projects
FOR EACH ROW EXECUTE PROCEDURE trigger_set_update_time();

CREATE TABLE IF NOT EXISTS modules (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    project_id UUID NOT NULL,
    name VARCHAR(255) NOT NULL,
    version TIMESTAMP WITH TIME ZONE,
    create_time TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    update_time TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (project_id)
        REFERENCES projects (id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TRIGGER on_update_modules BEFORE UPDATE ON modules
FOR EACH ROW EXECUTE PROCEDURE trigger_set_update_time();

CREATE INDEX IF NOT EXISTS modules_version_index ON modules (version);

CREATE TABLE IF NOT EXISTS module_contrib (
    module_id UUID NOT NULL,
    email_id UUID NOT NULL,
    dev_value FLOAT NOT NULL,
    create_time TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    update_time TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (module_id)
        REFERENCES modules (id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (email_id)
        REFERENCES emails (id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TRIGGER on_update_module_contrib BEFORE UPDATE ON module_contrib
FOR EACH ROW EXECUTE PROCEDURE trigger_set_update_time();

CREATE TABLE IF NOT EXISTS project_contrib (
    project_id UUID NOT NULL,
    email_id UUID NOT NULL,
    dev_value FLOAT NOT NULL,  -- sum of module dev-values
    distribution BYTEA,
    version TIMESTAMP WITH TIME ZONE NOT NULL,
    create_time TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    update_time TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (project_id)
        REFERENCES projects (id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (email_id)
        REFERENCES emails (id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TRIGGER on_update_project_contrib BEFORE UPDATE ON project_contrib
FOR EACH ROW EXECUTE PROCEDURE trigger_set_update_time();

CREATE INDEX IF NOT EXISTS project_contrib_version_index ON project_contrib (version);

CREATE TABLE IF NOT EXISTS subscriptions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    project_id UUID NOT NULL,
    user_id UUID NOT NULL,
    expiration TIMESTAMP WITH TIME ZONE,
    is_waiting BOOLEAN NOT NULL,
    create_time TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    update_time TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (project_id , user_id),
    FOREIGN KEY (project_id)
        REFERENCES projects (id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (user_id)
        REFERENCES users (id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TRIGGER on_update_subscriptions BEFORE UPDATE ON subscriptions
FOR EACH ROW EXECUTE PROCEDURE trigger_set_update_time();

CREATE TABLE IF NOT EXISTS migrate_log (
    "filename" VARCHAR,
    "version" INTEGER,
    "create_time" TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "update_time" TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY ("filename")
);

CREATE TRIGGER on_update_migrate_log BEFORE UPDATE ON migrate_log
FOR EACH ROW EXECUTE PROCEDURE trigger_set_update_time();
