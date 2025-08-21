FROM python:3.10-slim

WORKDIR /

# Install all required packages
RUN pip install --no-cache-dir runpod diffusers torch pillow fastapi uvicorn

# Copy handler into container
COPY rp_handler.py /

# Run FastAPI server
CMD ["python3", "-u", "rp_handler.py"]
