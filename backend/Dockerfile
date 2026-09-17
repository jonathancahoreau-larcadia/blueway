FROM python:3.12-slim

WORKDIR /app

COPY requirements.txt .
COPY app/infrastructure/database/requirements.txt database-requirements.txt

RUN pip install --no-cache-dir \
    -r requirements.txt \
    -r database-requirements.txt

COPY app ./app

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
