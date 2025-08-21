from fastapi import FastAPI, File, UploadFile, Form
from fastapi.responses import JSONResponse
from diffusers import DiffusionPipeline
import torch
from PIL import Image
import io
import os

app = FastAPI()

# Load model once
device = "cuda" if torch.cuda.is_available() else "cpu"
pipe = DiffusionPipeline.from_pretrained("Qwen/Qwen-Image-Edit").to(device)

# Health check
@app.get("/ping")
def ping():
    return {"status": "ok"}

# Image generation endpoint
@app.post("/generate")
async def generate(file: UploadFile = File(...), prompt: str = Form(...)):
    img = Image.open(io.BytesIO(await file.read()))
    result = pipe(prompt=prompt, image=img).images[0]
    buf = io.BytesIO()
    result.save(buf, format="PNG")
    return JSONResponse(content={"image": buf.getvalue().hex()})

# Run server
if __name__ == "__main__":
    import uvicorn
    port = int(os.environ.get("PORT", 8080))
    uvicorn.run(app, host="0.0.0.0", port=port)
