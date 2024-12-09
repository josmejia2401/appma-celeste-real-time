pip3 install --upgrade pip
pip3 install -r requirements.txt
# no agregar dependencias
pip3 install -r requirements.txt -t ./libs --no-deps
python3 training.py
python3 main.py

# para cargar dependencias de una carpeta en especifico

Para instalar en la carpeta:

pip3 install -r requirements.txt -t ./libs

Para leer en el archivo .py, al principio de todo agregar:
import sys
sys.path.insert(1, './libs')
sys.path.append('./libs')


# eliminar python de mac
which python3
sudo rm -rf /Library/Frameworks/Python.framework/Versions/3.13/bin/python3
sudo rm -rf "/Applications/Python 3.13/"
cd /usr/local/bin && ls -l | grep "/Library/Frameworks/Python.framework/Versions/3.13" | awk '{print $9}' | sudo xargs rm

# si sale error de gp con tensorflow añador esto:

import os
os.environ['TF_CPP_MIN_LOG_LEVEL'] = '1' 

import tensorflow as tf