#!/usr/bin/env python

import sys
import csv
import math
import matplotlib.pyplot

def get_values():
    index = []

    with open("data/audio_output.csv", "rb") as f:
        reader = csv.reader(f)
        try:
            for i,row in enumerate(reader):
                if i > 0:
                    vpp = float(row[2])
                    vrms = vpp / math.sqrt(8)

                    index.append({
                        "name": row[0],
                        "volume": row[1],
                        "vpp": vpp,
                        "vrms": vrms
                    })
        except csv.Error as err:
            sys.exit("File %s, line %d: %s" % (filename, reader.line_num, err))

    return index

if __name__ == "__main__":
    data = get_values()
    devices = []
    last_device = ""

    # Prepare the plot.
    matplotlib.pyplot.style.use("ggplot")         

    for device in data:
        if (last_device != device["name"]):
            print "\n" + device["name"]
            last_device = device["name"]

            devices.append({
                "name": last_device,
                "vpp": [],
                "vrms": [],
                "index": []
            })

        print "    {0}{1:.2f}Vpp    {2:.2f}Vrms".format(
                device["volume"] + (" " * (10 - len(device["volume"]))),
                device["vpp"],
                device["vrms"])

        devices[len(devices) - 1]["vpp"].append(device["vpp"])
        devices[len(devices) - 1]["vrms"].append(device["vrms"])
        devices[len(devices) - 1]["index"].append(len(devices) - 1)

    for i, _device in enumerate(devices):
        matplotlib.pyplot.plot(device[i]["vpp"], device[i]["index"], label = device[i]["name"])

    # Setup the plot.
    matplotlib.pyplot.title("Audio Output Volume")
    matplotlib.pyplot.legend(loc = "upper right")
    matplotlib.pyplot.xlabel("Voltage Peak-to-Peak (V)")
    matplotlib.pyplot.ylabel("Devices")
    matplotlib.pyplot.grid(True)
    matplotlib.pyplot.tight_layout()
    matplotlib.pyplot.show()

