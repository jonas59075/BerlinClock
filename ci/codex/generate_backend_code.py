#!/usr/bin/env python3
import argparse
import os
import sys
from pathlib import Path

try:
    from openai import OpenAI
except ImportError:
    print("Missing dependency: openai\nInstall with: pip install openai", file=sys.stderr)
    sys.exit(1)


def read_text(path: Path, description: str) -> str:
    if not path.exists():
        print(f"[WARN] {description} not found at {path}", file=sys.stderr)
        return ""
    return path.read_text(encoding="utf-8")


def build_prompt(prompt_template: str, spec: str, domain: str, api_service: str) -> str:
    parts = [
        prompt_template.strip(),
        "",
        "=== OPENAPI SPECIFICATION (YAML) ===",
        spec.strip(),
        "",
        "=== DOMAIN SPECIFICATION (MARKDOWN) ===",
        domain.strip(),
        "",
        "=== GENERATED GO API SERVICE (backend/gen/api/go/api_default_service.go) ===",
        api_service.strip(),
        "",
        "=== TASK ===",
        "Generate the complete Go backend implementation as requested above.",
        "Return ONLY Go code, no markdown fences, no explanations."
    ]
    return "\n".join(parts)


def generate_code(model: str, prompt: str) -> str:
    api_key = os.getenv("OPENAI_API_KEY")
    if not api_key:
        print("ERROR: Environment variable OPENAI_API_KEY is not set.", file=sys.stderr)
        sys.exit(1)

    client = OpenAI()

    # API call im neuen Responses-Format
    response = client.responses.create(
        model=model,
        input=prompt,
        max_output_tokens=8000,
    )

    # Neues Output-Format:
    # response.output -> Liste mit Items
    # Items vom Typ 'message' enthalten content[]
    for item in response.output:
        if item.type == "message":
            for c in item.content:
                if c.type == "text":
                    return c.text

    print("ERROR: No text output from model.", file=sys.stderr)
    sys.exit(1)



def main():
    parser = argparse.ArgumentParser(description="Generate Go backend code from spec + domain using OpenAI Codex-like model.")
    parser.add_argument("--spec", required=True, help="Path to OpenAPI spec (YAML)")
    parser.add_argument("--domain", required=True, help="Path to domain spec (Markdown)")
    parser.add_argument("--out", required=True, help="Output directory for generated Go code")
    parser.add_argument(
        "--model",
        default="gpt-4.1-mini",
        help="OpenAI model name to use for code generation"
    )
    parser.add_argument(
        "--prompt",
        default="ci/codex/prompts/backend-impl.prompt",
        help="Path to the Codex prompt template"
    )

    args = parser.parse_args()

    spec_path = Path(args.spec)
    domain_path = Path(args.domain)
    prompt_path = Path(args.prompt)
    api_service_path = Path("backend/gen/api/go/api_default_service.go")
    out_dir = Path(args.out)

    if not out_dir.exists():
        out_dir.mkdir(parents=True, exist_ok=True)

    prompt_template = read_text(prompt_path, "Prompt template")
    spec_text = read_text(spec_path, "OpenAPI spec")
    domain_text = read_text(domain_path, "Domain spec")
    api_service_text = read_text(api_service_path, "Generated API service")

    if not spec_text or not domain_text or not api_service_text or not prompt_template:
        print("ERROR: Missing required input content. Aborting.", file=sys.stderr)
        sys.exit(1)

    full_prompt = build_prompt(prompt_template, spec_text, domain_text, api_service_text)

    print("[INFO] Calling OpenAI API for backend code generation...", file=sys.stderr)
    code = generate_code(args.model, full_prompt)

    out_file = out_dir / "berlin_clock_backend.generated.go"
    out_file.write_text(code, encoding="utf-8")
    print(f"[INFO] Generated backend code written to {out_file}", file=sys.stderr)


if __name__ == "__main__":
    main()
