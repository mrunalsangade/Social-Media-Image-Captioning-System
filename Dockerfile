# Dockerfile
FROM python:3.12-slim

WORKDIR /app

# Install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

# Expose the port your app uses
EXPOSE 5000

# Launch via gunicorn
CMD ["gunicorn", "app:app", "-b", "0.0.0.0:5000"]
