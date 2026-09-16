"""Atomic SQL migrations with checksums and a transaction-scoped advisory lock."""
import argparse
import hashlib
import os
from pathlib import Path

import psycopg

MIGRATIONS = Path(__file__).with_name('migrations')
LOCK_ID = 6212091601


def migrate(dsn, direction='up', migrations=MIGRATIONS):
    files = sorted(migrations.glob('*.up.sql'))
    catalog = {p.name.removesuffix('.up.sql'): p for p in files}
    with psycopg.connect(dsn) as conn:
        conn.execute('SELECT pg_advisory_xact_lock(%s)', (LOCK_ID,))
        conn.execute('CREATE SCHEMA IF NOT EXISTS blueway_meta')
        conn.execute('''CREATE TABLE IF NOT EXISTS blueway_meta.schema_migrations (
            version text PRIMARY KEY, checksum text NOT NULL,
            applied_at timestamptz NOT NULL DEFAULT now())''')
        applied = dict(conn.execute('SELECT version, checksum FROM blueway_meta.schema_migrations ORDER BY version'))
        for version, checksum in applied.items():
            if version not in catalog or hashlib.sha256(catalog[version].read_bytes()).hexdigest() != checksum:
                raise ValueError(f'Missing or modified applied migration: {version}')
        if list(applied) != list(catalog)[:len(applied)]:
            raise ValueError('Applied migrations are not a prefix of the catalog')
        if direction == 'down':
            if not applied:
                return []
            version = list(applied)[-1]
            conn.execute((migrations / f'{version}.down.sql').read_text())
            conn.execute('DELETE FROM blueway_meta.schema_migrations WHERE version = %s', (version,))
            return [f'reverted {version}']
        if direction != 'up':
            raise ValueError(f'Unknown direction: {direction}')
        result = []
        for version, path in catalog.items():
            if version in applied:
                continue
            conn.execute(path.read_text())
            conn.execute('INSERT INTO blueway_meta.schema_migrations (version, checksum) VALUES (%s, %s)',
                         (version, hashlib.sha256(path.read_bytes()).hexdigest()))
            result.append(f'applied {version}')
        return result


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('direction', choices=['up', 'down'], nargs='?', default='up')
    parser.add_argument('--allow-data-loss', action='store_true', help='Required for destructive rollback')
    args = parser.parse_args()
    if args.direction == 'down' and not args.allow_data_loss:
        parser.error('down drops application data; pass --allow-data-loss explicitly')
    for line in migrate(os.environ['DATABASE_URL'], args.direction):
        print(line)
