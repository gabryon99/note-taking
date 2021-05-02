## Note Taking

### Build Docker Image

To build the Docker Image execute the following command in your shell:

```bash
docker build -t note-taking .  
```

### Run the Image

To run the built image execute the following command and you will have the generated PDF inside the `out/` directory:

```bash
docker run -v /Users/gabryon/Projects/Markdowns/:/app/ note-taking 
```

