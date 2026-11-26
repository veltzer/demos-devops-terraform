"""
Just a lambda function
"""

import os


def lambda_handler(_event, _context):
    """ the actual lambfa handler """
    greeting = os.environ["GREETING"]
    return f"{greeting} from Lambda!"
