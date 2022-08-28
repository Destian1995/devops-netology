#!/usr/bin/env python3

import os

bash_command = ["cd ~/git", "git status -s"]
result_os = os.popen(' && '.join(bash_command)).read()
is_change = False
for result in result_os.split('\n'):
    if result.find('m' and '??') != -1:
        prepare_result = result.replace('\tmodified:   ', '')
        print(prepare_result)
        break
