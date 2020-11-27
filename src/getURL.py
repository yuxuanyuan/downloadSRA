#!/usr/bin/env python

# -*- coding: utf-8 -*-

import requests
import sys

ID=sys.argv[1]
url="https://trace.ncbi.nlm.nih.gov/Traces/sra/?run="+ID

print(url)

r = requests.get(url)
print(r.text.encode('utf-8'))
