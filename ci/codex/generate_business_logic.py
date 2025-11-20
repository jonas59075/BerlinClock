#!/usr/bin/env python3
import argparse
import os
from openai import OpenAI

client = OpenAI()

PROMPT_FILE = "ci/codex/prompts/backend_business.txt"
TARGET = "backend/src/berlin_clock_business.generated.go"


def load_prompt():
    if not os.path.exists(PROMPT_FILE):
        raise FileNotFoundError(f"Prompt template not found: {PROMPT_FILE}")

    with open(PROMPT_FILE, "r", encoding="utf-8") as f:
        return f.read()


def generate_code(model, prompt):
    response = client.chat.completions.create(
        model=model,
        messages=[
            {"role": "system", "content": "You are Codex generating the Berlin Clock business logic in Go."},
            {"role": "user", "content": prompt}
        ],
        temperature=0.0
    )

    content = response.choices[0].message.content

    if not content:
        raise RuntimeError("Model returned no text output.")

    return content


def write_output(code):
    os.makedirs(os.path.dirname(TARGET), exist_ok=True)
    with open(TARGET, "w", encoding="utf-8") as f:
        f.write(code)
    print(f"[INFO] Business logic written to {TARGET}")


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--model", required=True, help="OpenAI model to use")
    args = parser.parse_args()

    prompt = load_prompt()
    code = generate_code(args.model, prompt)
    write_output(code)


if __name__ == "__main__":
    main()
