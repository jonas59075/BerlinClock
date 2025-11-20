#!/usr/bin/env python3
import os
from openai import OpenAI

PROMPT_PATH = "ci/codex/prompts/business.txt"
DOMAIN_SPEC_PATH = "spec/berlin_clock_business.domain.yaml"
OUTPUT_PATH = "backend/src/business_logic.generated.go"

def load_prompt():
    with open(PROMPT_PATH, "r") as f:
        return f.read()

def load_spec():
    with open(DOMAIN_SPEC_PATH, "r") as f:
        return f.read()

def build_final_prompt():
    prompt = load_prompt()
    spec = load_spec()
    return f"{prompt}\n\n# DOMAIN SPEC\n{spec}"

def generate_code(model, prompt):
    client = OpenAI()

    response = client.chat.completions.create(
        model=model,
        messages=[{"role": "user", "content": prompt}],
        max_tokens=4000,
        temperature=0.0,
    )

    return response.choices[0].message.content

def write_output(code):
    os.makedirs(os.path.dirname(OUTPUT_PATH), exist_ok=True)
    with open(OUTPUT_PATH, "w") as f:
        f.write(code)

def main():
    prompt = build_final_prompt()
    code = generate_code("gpt-4.1", prompt)
    write_output(code)
    print(f"[INFO] Business logic written to {OUTPUT_PATH}")

if __name__ == "__main__":
    main()
