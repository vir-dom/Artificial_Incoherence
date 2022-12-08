FROM python:3.10.1-slim
ADD app.py .
COPY requirements.txt .
RUN pip install --upgrade pip -r requirements.txt
COPY .  .
EXPOSE 5000
CMD [ "flask", "run", "--host=0.0.0.0","--port=5000" ]