from __future__ import annotations


_OPERATORS: dict[str, tuple[str, object]] = {
    "LT": (" less than ", lambda a, b: a < b),
    "LE": (" less or equal to ", lambda a, b: a <= b),
    "EQ": (" equal to ", lambda a, b: a == b),
    "GE": (" greater or equal to ", lambda a, b: a >= b),
    "GT": (" greater than ", lambda a, b: a > b),
    "NE": (" not equal to ", lambda a, b: a != b),
    "M2": (" is modulo 2 equal to", lambda a, b: (a % 2) == (b % 2)),
}


def compare(left_side: int, comp: str, right_side: int) -> bool:
    """Compare two integers using a named operator string.

    The *comp* string is checked with ``in`` (substring match) against
    operator codes: LT, LE, EQ, GE, GT, NE, M2.

    Java: forge.util.Expressions.compare
    """
    for code, (_, func) in _OPERATORS.items():
        if code in comp:
            return func(left_side, right_side)
    return False


def operator_name(comp: str) -> str:
    """Return a human-readable label for a comparison operator code.

    Java: forge.util.Expressions.operatorName
    """
    for code, (name, _) in _OPERATORS.items():
        if code in comp:
            return name
    return " ? "
