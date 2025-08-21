FROM python:3.10-slim

WORKDIR /

# Install system dependencies needed for torch and diffusers
RUN apt-get update && apt-get install -y \
    git \
    curl \
    build-essential \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender-dev \
    && rm -rf /var/lib/apt/lists/*

# Upgrade pip to latest
RUN python -m pip install --upgrade pip

# Install required Python packages
RUN pip install --no-cache-dir \
    torch \
    diffusers \
    pillow \
    fastapi \
    uvicorn

# Copy your FastAPI handler
COPY rp_handler.py /

# Run the server
CMD ["python3", "-u", "rp_handler.py"]
