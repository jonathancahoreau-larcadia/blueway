"""Sonde temporaire BLU-50 : prouve qu'une PR devient rouge sur un échec."""


def test_ci_reports_an_intentional_failure():
    assert False, "BLU-50: intentional CI failure proof; remove after recording the run"
