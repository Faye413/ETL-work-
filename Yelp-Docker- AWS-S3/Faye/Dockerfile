FROM python:2.7  

ADD run-scripts.sh .
ADD project.py .

ADD . /Faye
WORKDIR /Faye
RUN easy_install -U setuptools
RUN pip install -r requirements.txt

#RUN ./run-scripts.sh


#RUN ls
#RUN python --version

#ADD . /Faye
#WORKDIR /Faye
#RUN easy_install -U setuptools
#RUN pip install -r requirements.txt
#RUN python project.py


#RUN ls
#RUN head -10 output.csv