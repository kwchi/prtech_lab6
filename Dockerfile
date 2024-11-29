FROM python:3
COPY . /app
WORKDIR /app
EXPOSE 8080
CMD ["python", "./app.py"]
