"""Make users email required.

Revision ID: 20260920_0002
Revises: 20260917_0001
Create Date: 2026-09-20
"""

from alembic import op


revision = "20260920_0002"
down_revision = "20260917_0001"
branch_labels = None
depends_on = None


def upgrade() -> None:
    op.execute(
        """
        ALTER TABLE blueway.users
        ALTER COLUMN email SET NOT NULL
        """
    )


def downgrade() -> None:
    op.execute(
        """
        ALTER TABLE blueway.users
        ALTER COLUMN email DROP NOT NULL
        """
    )
