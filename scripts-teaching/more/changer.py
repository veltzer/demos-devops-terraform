"""
script to print terraform vars
"""

import re

with open('names.txt', encoding="utf8") as namefile, open('terraform.tfvars', encoding="utf8") as stream:
    for line in stream:
        if line.startswith('  {'):
            print(re.sub('---', namefile.readline().strip(), line), end='')
        else:
            print(line, end='')
