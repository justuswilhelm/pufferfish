#!/usr/bin/env python3
"""Python3 script template"""
import logging
from argparse import ArgumentParser

logging.basicConfig(level=logging.DEBUG)


def main(**args):
    """Main method."""


if __name__ == "__main__":
    argparser = ArgumentParser()
    args = vars(argparser.parse_args())
    main(**args)
