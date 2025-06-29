""" python deps for this project """

build_requires: list[str] = [
    "pydmt",
    "pymakehelper",
    "pycmdtools",

    "pytest",
    "pylint",
    "mypy",
    "ruff",
]
requires = build_requires
