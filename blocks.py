import os
def load_snippet(name):
    path = f"snippets/{name}.py"
    if os.path.exists(path):
        with open(path) as f:
            return f.read()
    return ""
def build_project(blocks):
    assembled = "\n\n".join([load_snippet(b) for b in blocks])
    with open("output.py", "w") as f:
        f.write(assembled)
    print("[+] Built output.py")
if __name__ == "__main__":
    blocks = ["init", "main", "cli"]
    build_project(blocks)
