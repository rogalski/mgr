#!/usr/bin/env python3
import os
import gzip
import shutil
import tarfile
import zipfile
import requests

CIRCUITS_DIR = "circuits"
ROMMES_CIRCUITS_DIR = os.path.join(CIRCUITS_DIR, "rommes")
ROMMES2_CIRCUITS_DIR = os.path.join(CIRCUITS_DIR, "rommes2")


def ensure_dst_dir():
    os.makedirs(CIRCUITS_DIR, exist_ok=True)
    os.makedirs(ROMMES_CIRCUITS_DIR, exist_ok=True)
    os.makedirs(ROMMES2_CIRCUITS_DIR, exist_ok=True)


def _download_to_file(url, dst, filename=None):
    if not filename:
        filename = os.path.basename(url)

    r = requests.get(url, stream=True)
    r.raise_for_status()
    with open(os.path.join(dst, filename), 'wb') as f:
        shutil.copyfileobj(r.raw, f)
    return f.name


def main():
    ensure_dst_dir()
    base_url = "https://sites.google.com/site/rommes/software/"
    for url in ["network_b.mat", "network_c.mat"]:
        _download_to_file(base_url + url, ROMMES2_CIRCUITS_DIR)

    for url in ["r_network_int46k_ext8k_res67k_public.mat",
                "r_network_int48k_ext8k_res75k_public.mat",
                "r_network_int50k_ext4k_res94k_public.mat"]:
        _download_to_file(base_url + url, ROMMES_CIRCUITS_DIR)


if __name__ == "__main__":
    main()
