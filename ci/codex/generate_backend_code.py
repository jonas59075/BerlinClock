import argparse
import openai
from pathlib import Path

# ------------------------------------------------------------
# LOAD DOMAIN SPEC
# ------------------------------------------------------------
def load_domain_spec():
    spec_path = Path("spec/berlin_clock_backend.domain.yaml")
    if not spec_path.exists():
        raise FileNotFoundError(f"Domain spec not found: {spec_path}")
    return spec_path.read_text(encoding="utf-8")


# ------------------------------------------------------------
# LOAD PROMPT TEMPLATE
# ------------------------------------------------------------
def load_prompt_template():
    prompt_path = Path("ci/codex/prompts/backend.txt")
    if not prompt_path.exists():
        raise FileNotFoundError(f"Prompt template not found: {prompt_path}")
    return prompt_path.read_text(encoding="utf-8")


# ------------------------------------------------------------
# BUILD FINAL PROMPT
# ------------------------------------------------------------
def build_prompt():
    domain_spec = load_domain_spec()
    template = load_prompt_template()

    final_prompt = template.replace("{{DOMAIN_SPEC}}", domain_spec)
    return final_prompt


# ------------------------------------------------------------
# CALL OPENAI
# ------------------------------------------------------------
def generate_code(model, prompt):
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

    # Extract text output
    content = response.choices[0].message["content"]
    if not content or len(content.strip()) == 0:
        raise RuntimeError("ERROR: No text output from model.")
    
    return content


# ------------------------------------------------------------
# WRITE GENERATED GO CODE
# ------------------------------------------------------------
def write_output(go_code: str):
    target_path = Path("backend/src/berlin_clock_backend.generated.go")
    target_path.parent.mkdir(parents=True, exist_ok=True)
    target_path.write_text(go_code, encoding="utf-8")

    print(f"[INFO] Generated backend code written to {target_path}")


# ------------------------------------------------------------
# MAIN
# ------------------------------------------------------------
def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--model", required=True)
    args = parser.parse_args()

    prompt = build_prompt()
    code = generate_code(args.model, prompt)
    write_output(code)


if __name__ == "__main__":
    main()
