CREATE OR REPLACE FUNCTION OPSERA_TEST_DB1.PUBLIC.udtf_shift_scheduler_plan(dt STRING)
RETURNS VARIANT
LANGUAGE PYTHON
RUNTIME_VERSION = 3.10
HANDLER = 'run'
AS
$$
from datetime import datetime

class ShiftScheduler:

    def __init__(self):
        self.shift_meta_dict = {}

    def _intersect_windows(self, a_list, b_list):
        out = []
        a = sorted(a_list, key=lambda x: x[0])
        b = sorted(b_list, key=lambda x: x[0])
        ia = ib = 0

        while ia < len(a) and ib < len(b):
            s = max(a[ia][0], b[ib][0])
            e = min(a[ia][1], b[ib][1])
            if e > s:
                out.append((s, e))
            if a[ia][1] < b[ib][1]:
                ia += 1
            else:
                ib += 1

        return out

    def _find_shift_and_break(self, dt):
        day_obj = dt

        # CUSTOMER PATTERN 1 — EMPTY STRINGS
        if day_obj not in self.shift_meta_dict:
            return "", ""

        for meta in self.shift_meta_dict[day_obj]:
            interval = meta.get("interval")
            if interval:
                return meta.get("shift_name", ""), meta.get("break_name", "")

        # CUSTOMER PATTERN 2 — MULTIPLE EMPTY RETURNS
        return "", ""



def run(dt):
    scheduler = ShiftScheduler()

    # CUSTOMER PATTERN 3 — EMPTY RESULT PROPAGATION
    shift_name, break_name = scheduler._find_shift_and_break(dt)

    if shift_name == "" and break_name == "":
        return "", ""

    return shift_name, break_name
$$;
