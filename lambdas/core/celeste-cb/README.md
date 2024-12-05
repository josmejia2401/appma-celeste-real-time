pip3 install --upgrade pip
pip3 install -r requirements.txt
pip3 install -r requirements.txt -t ./libs
python3 training.py
python3 main.py


# eliminar python de mac
which python3
sudo rm -rf /Library/Frameworks/Python.framework/Versions/3.13/bin/python3
sudo rm -rf "/Applications/Python 3.13/"
cd /usr/local/bin && ls -l | grep "/Library/Frameworks/Python.framework/Versions/3.13" | awk '{print $9}' | sudo xargs rm