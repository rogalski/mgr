#!/usr/bin/python3
import os
import gzip
import shutil
import tarfile
import zipfile
import requests

THIRD_PARTY_DIR = "third_party"


def ensure_dst_dir():
    os.makedirs(THIRD_PARTY_DIR, exist_ok=True)


def download_matlab_bgl():
    url = "http://www.mathworks.com/matlabcentral/mlc-downloads/downloads/submissions/10922/versions/2/download/zip"
    return _download_to_file(url, 'matlab_bgl.zip')


def extract_matlab_bgl(matlab_bgl_zip):
    with zipfile.ZipFile(matlab_bgl_zip) as archive:
        archive.extractall(THIRD_PARTY_DIR)
    os.unlink(matlab_bgl_zip)


def download_metis():
    url = "http://glaros.dtc.umn.edu/gkhome/fetch/sw/metis/metis-5.1.0.tar.gz"
    return _download_to_file(url)


def extract_metis(metis_tar_gz):
    _extract_tar_gz(metis_tar_gz)


def download_suitesparse():
    url = "http://faculty.cse.tamu.edu/davis/SuiteSparse/SuiteSparse-4.4.6.tar.gz"
    return _download_to_file(url)


def extract_suitesparse(suitesparse_tar_gz):
    _extract_tar_gz(suitesparse_tar_gz)


def _download_to_file(url, tmp_name=None):
    if not tmp_name:
        tmp_name = os.path.basename(url)

    r = requests.get(url, stream=True)
    r.raise_for_status()
    with open(os.path.join(THIRD_PARTY_DIR, tmp_name), 'wb') as f:
        shutil.copyfileobj(r.raw, f)
    return f.name


def _extract_tar_gz(file_path):
    # TODO: tarfile should be able to do it, but raises InvalidHeader error
    with gzip.GzipFile(file_path) as gzipped_archive:
        with tarfile.TarFile(fileobj=gzipped_archive) as archive:
            archive.extractall(THIRD_PARTY_DIR)
    os.unlink(file_path)


def main():
    ensure_dst_dir()
    extract_matlab_bgl(download_matlab_bgl())
    extract_metis(download_metis())
    extract_suitesparse(download_suitesparse())


if __name__ == "__main__":
    main()
