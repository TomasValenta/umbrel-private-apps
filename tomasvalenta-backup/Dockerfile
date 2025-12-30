FROM python:3.12-slim

RUN apt-get update && apt-get install -y \
    rsync \
    bash \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app/ /app/
COPY scripts/ /scripts/

RUN chmod +x /scripts/backup.sh

EXPOSE 5000

USER 1000:1000

CMD ["python", "server.py"]