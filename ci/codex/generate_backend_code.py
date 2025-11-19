#!/usr/bin/env python3
import argparse
import os
from openai import OpenAI

# Initialize OpenAI client
client = OpenAI()


PROMPT_FILE = "ci/codex/prompts/backend.txt"


def load_prompt():
    if not os.path.exists(PROMPT_FILE):
        raise FileNotFoundError(f"Prompt template not found: {PROMPT_FILE}")

    with open(PROMPT_FILE, "r", encoding="utf-8") as f:
        return f.read()


def build_prompt():
    base_prompt = load_prompt()
    return base_prompt


def generate_code(model, prompt):
    response = client.chat.completions.create(
        model=model,
        messages=[
            {"role": "system", "content": "You are Codex generating backend Go code for the Berlin Clock."},
            {"role": "user", "content": prompt}
        ],
        temperature=0.0
    )

    # New OpenAI response format
    content = response.choices[0].message.content

    if not content:
        raise ValueError("No text output from model.")

    return content


def write_output(code):
    os.makedirs("backend/src", exist_ok=True)
    target = "backend/src/berlin_clock_backend.generated.go"

    with open(target, "w", encoding="utf-8") as f:
        f.write(code)

    print(f"[INFO] Generated backend code written to {target}")


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--model", required=True, help="OpenAI model to use")
    args = parser.parse_args()

    prompt = build_prompt()
    code = generate_code(args.model, prompt)
    write_output(code)


if __name__ == "__main__":
    main()
