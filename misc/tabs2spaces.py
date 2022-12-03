import os
import argparse


def format(filename, dry, verbose):

    if not filename.endswith(".gd"):
        return

    if verbose:
        print(filename)

    if dry:
        return 

    with open(filename, "r") as f:
        text = f.read()

    with open(filename, "w") as f:
        f.write(text.replace("\t", " " * 4))

    print("formatted")


def main(path, dry, verbose):

    if os.path.isfile(path):
        format(path, dry, verbose)

    for dirpath, _, filenames in os.walk(path):
        for filename in filenames:
            filename_full = os.path.join(dirpath, filename)
            format(filename_full, dry, verbose)


if __name__ == "__main__":

    parser = argparse.ArgumentParser()
    parser.add_argument('path')
    parser.add_argument('--dry', action="store_true")
    parser.add_argument('--verbose', action="store_false")
    args = parser.parse_args()

    main(args.path, args.dry, args.verbose)
