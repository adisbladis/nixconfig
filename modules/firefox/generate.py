#!/usr/bin/env python
from concurrent.futures import ThreadPoolExecutor
import requests
import json


EXTENSIONS = sorted([
    "browserpass-ce",
    "cookie-quick-manager",
    "cors-everywhere",
    "decentraleyes",
    "https-everywhere",
    "reddit-enhancement-suite",
    "reddit-sidebar-getter-ridder",
    "amp2html",
    "saka-key",
    "stylus",
    "togglewebsitecolors",
    "ublock-origin",
    "user-agent-switcher-revived",
    "darkreader",
])


def index_ext(ext: str):
    print(f"Indexing {ext}...")

    resp = requests.get(f"https://addons.mozilla.org/api/v5/addons/addon/{ext}/").json()
    rel = resp["current_version"]

    if not rel["file"]["hash"].startswith("sha256:"):
        raise ValueError("Unhandled hash type")

    return {
        "pname": ext,
        "version": rel["version"],
        "addonId": resp["guid"],
        "url": rel["file"]["url"],
        "sha256": rel["file"]["hash"],
    }


if __name__ == "__main__":

    outfile = "extensions.json"

    with ThreadPoolExecutor() as e:
        extensions = {ext: e.submit(index_ext, ext) for ext in EXTENSIONS}
        extensions = {k: v.result() for k, v in extensions.items()}

    with open(outfile, "w") as f:
        json.dump(extensions, f, indent=2)
