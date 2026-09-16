import importlib.util
import os
from pathlib import Path
import uuid

import psycopg
from psycopg import sql
from psycopg.conninfo import conninfo_to_dict, make_conninfo
import pytest

ROOT = Path(__file__).resolve().parents[3]
spec = importlib.util.spec_from_file_location('blueway_migrate', ROOT / 'backend/app/infrastructure/database/migrate.py')
migrations = importlib.util.module_from_spec(spec)
spec.loader.exec_module(migrations)


@pytest.fixture(scope='session')
def dsn():
    """Never reset an existing database. Create and drop our own random database."""
    admin_dsn = os.environ['BLUEWAY_TEST_ADMIN_URL']
    name = 'blueway_test_' + uuid.uuid4().hex
    params = conninfo_to_dict(admin_dsn)
    params['dbname'] = name
    test_dsn = make_conninfo(**params)
    with psycopg.connect(admin_dsn, autocommit=True) as admin:
        admin.execute(sql.SQL('CREATE DATABASE {}').format(sql.Identifier(name)))
    try:
        migrations.migrate(test_dsn)
        yield test_dsn
    finally:
        with psycopg.connect(admin_dsn, autocommit=True) as admin:
            admin.execute(sql.SQL('DROP DATABASE {} WITH (FORCE)').format(sql.Identifier(name)))


def insert(conn, table, **values):
    query = sql.SQL('INSERT INTO blueway.{} ({}) VALUES ({}) RETURNING *').format(
        sql.Identifier(table), sql.SQL(',').join(map(sql.Identifier, values)),
        sql.SQL(',').join(sql.Placeholder() for _ in values))
    return conn.execute(query, list(values.values())).fetchone()


def seed(conn):
    from datetime import datetime, timezone, timedelta
    now = datetime.now(timezone.utc)
    ids = {x: uuid.uuid4() for x in ['user', 'admin', 'boat', 'device', 'report', 'manual', 'notification', 'history', 'audit']}
    for user, role in [('user','user'), ('admin','admin')]:
        insert(conn, 'users', id=ids[user], firebase_uid=str(ids[user]), username=str(ids[user]),
               role=role, status='active', created_at=now, updated_at=now)
    insert(conn, 'boats', id=ids['boat'], user_id=ids['user'], boat_type='voilier', created_at=now, updated_at=now)
    insert(conn, 'devices', id=ids['device'], user_id=ids['user'], installation_id=uuid.uuid4(),
           platform='ios', is_active=True, last_seen_at=now)
    point = 'SRID=4326;POINT(5 43)'
    insert(conn, 'device_positions', device_id=ids['device'], position=point, accuracy_m=50,
           measured_at=now, received_at=now)
    for report, mode in [('report','photo'), ('manual','manual')]:
        insert(conn, 'reports', id=ids[report], author_id=ids['user'], client_report_id=uuid.uuid4(),
               category='pollution', positioning_mode=mode, final_position=point, observed_at=now,
               created_at=now, expires_at=now+timedelta(hours=24), status='active', updated_at=now)
    insert(conn, 'report_positioning', report_id=ids['report'], observer_position=point, gps_accuracy_m=0,
           azimuth_deg=0, inclination_deg=-10, camera_height_m=2, captured_at=now)
    insert(conn, 'report_photos', report_id=ids['report'], upload_status='pending', created_at=now, updated_at=now)
    insert(conn, 'notifications', id=ids['notification'], report_id=ids['report'], device_id=ids['device'],
           report_version=1, status='pending', next_attempt_at=now, created_at=now, updated_at=now)
    insert(conn, 'alert_history', id=ids['history'], user_id=ids['user'], report_id=ids['report'],
           report_version=1, category='pollution', position=point, distance_m=18520, alerted_at=now)
    insert(conn, 'moderation_actions', id=ids['audit'], admin_user_id=ids['admin'], target_report_id=ids['report'],
           action='remove_report', reason='Reported obstruction verified', created_at=now)
    return ids


@pytest.fixture
def db(dsn):
    with psycopg.connect(dsn) as conn:
        ids = seed(conn)
        conn.commit()
        try:
            yield conn, ids
        finally:
            conn.rollback()
