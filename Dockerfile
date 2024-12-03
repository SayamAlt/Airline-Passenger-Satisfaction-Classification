# Use official Python runtime as a parent image
FROM python:3.8-slim

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install dependencies
RUN python -m venv venv
RUN . venv/bin/activate && pip install --upgrade pip
RUN . venv/bin/activate && pip install -r requirements.txt

# Expose the Flask app's port (default port for Flask is 5000, but we use 8000 for production on Azure)
EXPOSE 8000

# Command to run the app using Gunicorn
CMD ["sh", "-c", ". venv/bin/activate && gunicorn -b 0.0.0.0:8000 app.app:app"]
