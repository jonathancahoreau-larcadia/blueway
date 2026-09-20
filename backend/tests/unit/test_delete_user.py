import pytest

from app.application.ports.auth_provider import AuthProvider
from app.application.ports.user_repository import UserRepository
from app.application.services.delete_user import DeleteUser
from app.domain.errors import UserNotFoundError
from app.domain.user import User


class FakeUserRepository(UserRepository):
    def __init__(self):
        self.users = []

    def get_by_firebase_uid(self, firebase_uid: str) -> User | None:
        for user in self.users:
            if user.firebase_uid == firebase_uid:
                return user

        return None

    def get_by_username(self, username: str) -> User | None:
        for user in self.users:
            if user.username == username:
                return user

        return None

    def save(self, user: User) -> User:
        self.users.append(user)
        return user

    def update(self, user: User) -> User:
        return user

    def delete(self, user: User) -> None:
        self.users.remove(user)


class FakeAuthProvider(AuthProvider):
    def __init__(self):
        self.deleted_uids = []

    def delete_identity(self, firebase_uid: str) -> None:
        self.deleted_uids.append(firebase_uid)


def test_delete_user_success():
    repository = FakeUserRepository()
    auth_provider = FakeAuthProvider()

    user = User(
        firebase_uid="firebase_123",
        username="Jonathan",
        email="jonathan@example.com",
    )

    repository.save(user)

    delete_user = DeleteUser(
        user_repository=repository,
        auth_provider=auth_provider,
    )

    delete_user.execute("firebase_123")

    assert len(repository.users) == 0
    assert "firebase_123" in auth_provider.deleted_uids


def test_delete_user_not_found_raises_error():
    repository = FakeUserRepository()
    auth_provider = FakeAuthProvider()

    delete_user = DeleteUser(
        user_repository=repository,
        auth_provider=auth_provider,
    )

    with pytest.raises(UserNotFoundError):
        delete_user.execute("unknown_uid")

    assert len(repository.users) == 0
    assert len(auth_provider.deleted_uids) == 0
