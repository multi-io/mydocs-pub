from datetime import datetime
import numpy as np
from importlib import resources


def get_past_lod_deltas(
    filename="./eopc04_IAU2000.62-now",
):
    dates = []
    lods = []

    with resources.files(__package__).joinpath(
        filename
    ).open("r", encoding="utf-8") as file:
        for line in file:
            if not line or line.startswith("#") or line.startswith(" ") or line.startswith("\t"):
                continue

            parts = line.split()
            if len(parts) < 8:
                continue

            year = int(parts[0])
            month = int(parts[1])
            day = int(parts[2])
            lod = float(parts[7])

            dates.append(np.datetime64(datetime(year, month, day)))
            lods.append(lod)

    return dates, lods
