CREATE EXTENSION "uuid-ossp";

CREATE TYPE user_role AS ENUM ('creator', 'collaborator', 'member');

CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v1mc(),
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    handle VARCHAR(255) UNIQUE NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL CHECK (email ~ '^[a-z\-\+_0-9\.]+@[a-z\-\+_0-9]+\.[a-z\-\+_0-9\.]+$'),
    avatar_url VARCHAR(255),
    external_id VARCHAR(255) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT now()
);

CREATE TABLE workspaces (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v1mc(),
    handle VARCHAR(20) UNIQUE NOT NULL CHECK (handle ~ '^[a-z\-\+_0-9\.]+$'),
    description TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT now(),
    created_by UUID REFERENCES users NOT NULL
);

CREATE TABLE user_workspaces (
    user_id UUID REFERENCES users NOT NULL,
    workspace_id UUID REFERENCES workspaces NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT now(),
    created_by UUID REFERENCES users NOT NULL,
    PRIMARY KEY (user_id, workspace_id)
);

CREATE TABLE channels (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v1mc(),
    workspace_id UUID REFERENCES workspaces NOT NULL,
    handle VARCHAR(20) NOT NULL CHECK (handle ~ '^[a-z\-\+_0-9\.]+$'),
    purpose VARCHAR(255),
    private BOOLEAN NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT now(),
    created_by UUID REFERENCES users NOT NULL,
    CONSTRAINT channels_workspace_id_handle UNIQUE(workspace_id, handle)
);

CREATE TABLE user_channels (
    user_id UUID REFERENCES users NOT NULL,
    channel_id UUID REFERENCES channels NOT NULL,
    user_channel_role user_role NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT now(),
    created_by UUID REFERENCES users NOT NULL,
    PRIMARY KEY (user_id, channel_id)
);

CREATE TABLE conversations (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v1mc(),
    workspace_id UUID REFERENCES workspaces NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT now(),
    created_by UUID REFERENCES users NOT NULL
);

CREATE TABLE user_conversations (
    user_id UUID REFERENCES users NOT NULL,
    conversation_id UUID REFERENCES conversations NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT now(),
    created_by UUID REFERENCES users NOT NULL,
    PRIMARY KEY (user_id, conversation_id)
);

CREATE TABLE emoji (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v1mc(),
    utf_string VARCHAR(10) UNIQUE NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT now(),
    created_by UUID REFERENCES users NOT NULL
);

CREATE TABLE emoji_aliases (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v1mc(),
    emoji_id UUID REFERENCES emoji NOT NULL,
    handle VARCHAR(255) UNIQUE NOT NULL CHECK (handle ~ '^[a-z\-\+_0-9\.]+$'),
    created_at TIMESTAMP NOT NULL DEFAULT now(),
    created_by UUID REFERENCES users NOT NULL
);

CREATE TABLE entries (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v1mc(),
    channel_id UUID REFERENCES channels,
    conversation_id UUID REFERENCES conversations,
    parent_entry_id UUID REFERENCES entries,
    created_at TIMESTAMP NOT NULL DEFAULT now(),
    created_by UUID REFERENCES users NOT NULL,
    CONSTRAINT entries_channel_id_or_conversation_id_or_parent_entry_id CHECK
        ((channel_id IS NOT NULL AND conversation_id IS NULL AND parent_entry_id IS NULL)
         OR (channel_id IS NULL AND conversation_id IS NOT NULL AND parent_entry_id IS NULL)
         OR (channel_id IS NULL AND conversation_id IS NULL AND parent_entry_id IS NOT NULL))
);

CREATE TABLE attachments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v1mc(),
    entry_id UUID REFERENCES entries NOT NULL,
    filename VARCHAR(255),
    content_type VARCHAR(255),
    file_url VARCHAR(255),
    created_at TIMESTAMP NOT NULL DEFAULT now(),
    created_by UUID REFERENCES users NOT NULL
);

CREATE TABLE messages (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v1mc(),
    entry_id UUID REFERENCES entries UNIQUE NOT NULL,
    body TEXT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT now(),
    created_by UUID REFERENCES users NOT NULL
);

CREATE TABLE reactions (
    user_id UUID REFERENCES users NOT NULL,
    emoji_id UUID REFERENCES emoji NOT NULL,
    entry_id UUID REFERENCES entries NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT now(),
    created_by UUID REFERENCES users NOT NULL,
    PRIMARY KEY (user_id, emoji_id, entry_id)
);
