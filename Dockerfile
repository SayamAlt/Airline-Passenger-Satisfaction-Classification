# Step 1: Use a base image with Python 3.8
FROM python:3.8-slim

# Step 2: Set the working directory in the container
WORKDIR /app

# Step 3: Copy the entire project to the container's working directory
COPY . .

# Step 4: Install system dependencies for DVC and other libraries
RUN apt-get update && apt-get install -y \
    git \
    && rm -rf /var/lib/apt/lists/*

# Step 5: Install Python dependencies
RUN pip install --upgrade pip && \
    pip install -r requirements.txt && \
    pip install dvc[all] mlflow joblib pandas flask

# Step 6: Set up DVC remote (you might need to adjust this if using a different storage or configuration)
RUN dvc remote add -d myremote ./dvc_remote_storage

# Step 7: Pull the latest data and models from the DVC remote storage
RUN dvc pull

# Step 8: Run the DVC pipeline to reproduce any stages that need to be run (train, test, register, etc.)
RUN dvc repro

# Step 9: Run the DVC pipeline to push artifacts to the DVC remote storage
RUN dvc push

# Step 9: Expose the port Flask will run on
EXPOSE 2000

# Step 10: Run the Flask app (using run_flask.sh to orchestrate the startup)
ENTRYPOINT ["./run_flask.sh"]
