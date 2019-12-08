#
# Matplotlib config stolen here and there
#

import matplotlib as mpl
from cycler import cycler

mpl.rcParams.update(
    {
        "figure.figsize": (12.5, 4),
        "lines.linewidth": 2.0,
        "axes.edgecolor": "#bcbcbc",
        "patch.linewidth": 0.5,
        "legend.fancybox": True,
        "axes.prop_cycle": cycler('color', [
            "#348ABD",
            "#A60628",
            "#7A68A6",
            "#467821",
            "#CF4457",
            "#188487",
            "#E24A33"
        ]),
        "axes.facecolor": "#eeeeee",
        "axes.labelsize": "large",
        "axes.grid": True,
        "patch.edgecolor": "#eeeeee",
        "axes.titlesize": "x-large",
        "svg.fonttype": "path"
    }
)
