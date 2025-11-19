import argparse
from pathlib import Path
import openai


# ------------------------------------------------------------
# Load domain specification
# ------------------------------------------------------------
def load_domain_spec() -> str:
    spec_path = Path("spec/berlin_clock_backend.domain.yaml")
    if not spec_path.exists():
        raise FileNotFoundError(f"Domain spec not found: {spec_path}")
    return spec_path.read_text(encoding="utf-8")


# ------------------------------------------------------------
# Load prompt template
# ------------------------------------------------------------
def load_prompt() -> str:
    prompt_path = Path("ci/codex/prompts/backend.txt")
    if not prompt_path.exists():
        raise FileNotFoundError(f"Prompt template not found: {prompt_path}")
    return prompt_path.read_text(encoding="utf-8")


# ------------------------------------------------------------
# Merge prompt + spec
# ------------------------------------------------------------
def build_prompt() -> str:
    template = load_prompt()
    domain_spec = load_domain_spec()
    return template.replace("{{DOMAIN_SPEC}}", domain_spec)


# ------------------------------------------------------------
# Call OpenAI Codex/Chat Completions API
# ------------------------------------------------------------
def generate_code(model: str, prompt: str) -> str:
    client = openai.OpenAI()

    print("[INFO] Calling OpenAI API for backend code generation...")

    response = client.chat.completions.create(
        model=model,
        messages=[
            {"role": "system", "content": "You are Codex in strict SDD mode."},
            {"role": "user", "content": prompt},
        ],
        temperature=0,
    )

    # Extract final code
    content = response.choices[0].message["content"]
    if not content or not content.strip():
        raise RuntimeError("ERROR: No text output from model.")

    return content


# ------------------------------------------------------------
# Write generated Go code
# ------------------------------------------------------------
def write_code(go_code: str):
    target_path = Path("backend/src/berlin_clock_backend.generated.go")
    target_path.parent.mkdir(parents=True, exist_ok=True)
    target_path.write_text(go_code, encoding="utf-8")

    print(f"[INFO] Generated backend code written to: {target_path}")


# ------------------------------------------------------------
# MAIN
# ------------------------------------------------------------
def main():
    parser = argparse.ArgumentParser(description="Generate backend code via Codex (SDD mode).")
    parser.add_argument("--model", required=True, help="OpenAI model to use (e.g. gpt-4.1)")
    args = parser.parse_args()

    prompt = build_prompt()
    code = generate_code(args.model, prompt)
    write_code(code)


if __name__ == "__main__":
    main()
