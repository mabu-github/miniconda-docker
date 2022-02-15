from pathlib import Path

import uvicorn
from fastapi import FastAPI

app = FastAPI()


@app.get("/")
def index():
    if (Path(__file__).parent / "data").exists():  # local path
        data = (Path(__file__).parent / "data" / "data.txt").read_text()
    else:  # path in container
        data = (Path("/data/data.txt")).read_text()
    return {"data": data}


if __name__ == '__main__':
    uvicorn.run("main:app", host="localhost", port=8080)
