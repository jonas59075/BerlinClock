#!/usr/bin/env python3
import os
from openai import OpenAI

PROMPT_PATH = "ci/codex/prompts/backend.txt"
DOMAIN_SPEC = "spec/berlin_clock_business.domain.yaml"
OUTPUT = "backend/src/berlin_clock_backend.generated.go"

def load_file(path):
    with open(path, "r", encoding="utf-8") as f:
        return f.read()

def build_prompt():
    prompt = load_file(PROMPT_PATH)
    domain = load_file(DOMAIN_SPEC)
    return f"{prompt}\n\n# DOMAIN SPEC\n{domain}"

def generate_code(model, prompt):
    client = OpenAI()
    response = client.chat.completions.create(
        model=model,
        messages=[{"role": "user", "content": prompt}],
        temperature=0.0,
        max_tokens=6000,
    )
    return response.choices[0].message.content

def write_output(code):
    os.makedirs(os.path.dirname(OUTPUT), exist_ok=True)
    with open(OUTPUT, "w", encoding="utf-8") as f:
        f.write(code)

def main():
    prompt = build_prompt()
    code = generate_code("gpt-4.1", prompt)
    write_output(code)
    print(f"[INFO] Backend code written to {OUTPUT}")

if __name__ == "__main__":
    main()
