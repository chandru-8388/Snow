CREATE OR REPLACE FUNCTION repro_empty_string()
RETURNS VARIANT
LANGUAGE PYTHON
AS
$$
def _find_shift_and_break(dt):
    shift_meta_dict = {}

    if dt not in shift_meta_dict:
        return "", ""

    return "SHIFT", "BREAK"

def run():
    return _find_shift_and_break("2026-01-01")
$$;
