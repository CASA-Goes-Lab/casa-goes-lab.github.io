# Local figure picker for the Publications page (see server.py).
FROM python:3.12-slim
RUN pip install --no-cache-dir pymupdf==2.1
WORKDIR /app
COPY server.py index.html ./
EXPOSE 4001
CMD ["python", "server.py"]
