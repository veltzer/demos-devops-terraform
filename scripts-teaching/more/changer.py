"""
script to print terraform vars
"""

import re

with open('names.txt', encoding="utf8") as namefile:
    with open('terraform.tfvars', encoding="utf8") as stream:
        for line in stream:
            if line.startswith('  {'):
                line = re.sub('---', namefile.readline().strip(), line)
            print(line, end='')
