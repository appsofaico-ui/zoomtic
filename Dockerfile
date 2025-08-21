FROM python:3.10-slim

WORKDIR /

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    build-essential \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender-dev \
    && rm -rf /var/lib/apt/lists/*

# Upgrade pip first
RUN python -m pip install --upgrade pip

# Install Python packages (CPU torch)
RUN pip install --no-cache-dir \
    torch \
    diffusers \
    pillow \
    fastapi \
    uvicorn

# Copy handler
COPY rp_handler.py /

CMD ["python3", "-u", "rp_handler.py"]
