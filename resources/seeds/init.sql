INSERT INTO users (first_name, last_name, handle, email, external_id)
    VALUES ('Ben', 'Allred', 'skuttleman', 'skuttleman@gmail.com', '?');

INSERT INTO workspaces (handle, created_by)
    VALUES ('workspace', (SELECT id FROM users WHERE handle = 'skuttleman'));

INSERT INTO user_workspaces (user_id, workspace_id, created_by)
    VALUES ((SELECT id FROM users WHERE handle = 'skuttleman'),
            (SELECT id FROM workspaces WHERE handle = 'workspace'),
            (SELECT id FROM users WHERE handle = 'skuttleman'));

INSERT INTO channels (workspace_id, handle, private, created_by)
    VALUES ((SELECT id FROM workspaces WHERE handle = 'workspace'),
            'nonsense-abounds',
            'f',
            (SELECT id FROM users WHERE handle = 'skuttleman'));

INSERT INTO user_channels (user_id, channel_id, user_channel_role, created_by)
    VALUES ((SELECT id FROM users WHERE handle = 'skuttleman'),
            (SELECT id FROM channels WHERE handle = 'nonsense-abounds'),
            'creator',
            (SELECT id FROM users WHERE handle = 'skuttleman'));

INSERT INTO channels (workspace_id, handle, private, created_by)
    VALUES ((SELECT id FROM workspaces WHERE handle = 'workspace'),
            'general',
            'f',
            (SELECT id FROM users WHERE handle = 'skuttleman'));

INSERT INTO user_channels (user_id, channel_id, user_channel_role, created_by)
    VALUES ((SELECT id FROM users WHERE handle = 'skuttleman'),
            (SELECT id FROM channels WHERE handle = 'general'),
            'creator',
            (SELECT id FROM users WHERE handle = 'skuttleman'));
