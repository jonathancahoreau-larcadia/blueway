from app.application.ports.auth_provider import AuthProvider
from app.application.ports.user_repository import UserRepository
from app.domain.errors import UserNotFoundError


class DeleteUser:
    def __init__(
        self,
        user_repository: UserRepository,
        auth_provider: AuthProvider,
    ):
        self.user_repository = user_repository
        self.auth_provider = auth_provider

    def execute(self, firebase_uid: str) -> None:
        user = self.user_repository.get_by_firebase_uid(
            firebase_uid
        )

        if user is None:
            raise UserNotFoundError(
                "user profile not found"
            )

        self.user_repository.delete(user)

        self.auth_provider.delete_identity(
            firebase_uid
        )
