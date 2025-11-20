#!/usr/bin/env python3
import os
from openai import OpenAI

PROMPT_PATH = "ci/codex/prompts/frontend.txt"
DOMAIN_SPEC = "spec/berlin_clock_business.domain.yaml"
OUTPUT = "frontend/src/Main.elm"

def load(path):
    with open(path, "r", encoding="utf-8") as f:
        return f.read()

def build_prompt():
    prompt = load(PROMPT_PATH)
    domain = load(DOMAIN_SPEC)
    return f"{prompt}\n\n# DOMAIN SPEC\n{domain}"

def generate_code(model, prompt):
    client = OpenAI()
    resp = client.chat.completions.create(
        model=model,
        messages=[{"role": "user", "content": prompt}],
        temperature=0.0,
        max_tokens=8000,
    )
    return resp.choices[0].message.content

def write(code):
    os.makedirs(os.path.dirname(OUTPUT), exist_ok=True)
    with open(OUTPUT, "w", encoding="utf-8") as f:
        f.write(code)

def main():
    prompt = build_prompt()
    code = generate_code("gpt-4.1", prompt)
    write(code)
    print(f"[INFO] Frontend written to {OUTPUT}")

if __name__ == "__main__":
    main()
