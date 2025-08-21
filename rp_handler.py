import runpod
import torch
from diffusers import DiffusionPipeline
from PIL import Image
import io

device = "cuda" if torch.cuda.is_available() else "cpu"
pipe = DiffusionPipeline.from_pretrained("Qwen/Qwen-Image-Edit").to(device)

def handler(event):
    prompt = event["input"].get("prompt", "")
    image_bytes = event["input"].get("image")
    if not image_bytes:
        return {"error": "No image provided"}

    img = Image.open(io.BytesIO(image_bytes)).convert("RGB")
    result = pipe(prompt=prompt, image=img)
    
    out_img = result.images[0]
    buf = io.BytesIO()
    out_img.save(buf, format="PNG")
    buf.seek(0)

    return {"image": buf.getvalue().hex()}

if __name__ == "__main__":
    runpod.serverless.start({"handler": handler})
