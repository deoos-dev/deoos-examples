# Multi-arch handoff

Same six-step host maintenance run as `python/multi-arch-handoff`. `os.machine()` is recorded on each step. Either worker can resume a task the other SDK started.

The module is `maintain.mjs`. `python tests/multi_arch_handoff_demo.py` runs both.
