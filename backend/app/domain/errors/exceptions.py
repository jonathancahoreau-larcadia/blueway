class DomainError(Exception):
    pass


class ReportNotFoundError(DomainError):
    pass


class InvalidFirebaseUidError(DomainError):
    pass


class InvalidUsernameError(DomainError):
    pass


class InvalidEmailError(DomainError):
    pass


class InvalidNationalityError(DomainError):
    pass


class UserAlreadyExistsError(DomainError):
    pass


class UsernameAlreadyExistsError(DomainError):
    pass


class UserNotFoundError(DomainError):
    pass


class EmailNotVerifiedError(DomainError):
    pass
