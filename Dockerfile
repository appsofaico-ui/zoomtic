# Use slim Python image
FROM python:3.10-slim

# Set working directory
WORKDIR /

# Install system dependencies for torch / diffusers
RUN apt-get update && apt-get install -y \
    git \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender-dev \
    && rm -rf /var/lib/apt/lists/*

# Install only required Python packages
RUN pip install --no-cache-dir \
    torch --index-url https://download.pytorch.org/whl/cpu \
    diffusers \
    pillow \
    fastapi \
    uvicorn

# Copy FastAPI handler
COPY rp_handler.py /

# Run FastAPI server
CMD ["python3", "-u", "rp_handler.py"]
