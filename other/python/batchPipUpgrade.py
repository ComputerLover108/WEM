import pip
import re
from subprocess import call
#  
for dist in pip.get_installed_distributions():
    call("pip install --upgrade " + dist.project_name, shell=True)

# version = pip.__version__
# x = version.split('.')
# if int(x[0]) > 9 :
#     print(x[0])
