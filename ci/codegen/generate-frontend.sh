echo "Fixing Elm module names..."

# Universal sed (Linux + macOS) using temp files

apply_sed() {
  local file="$1"
  local find="$2"
  local replace="$3"

  # Create temp file
  tmpfile=$(mktemp)

  # Apply replacement portable across Linux/macOS
  sed "s/${find}/${replace}/" "$file" > "$tmpfile"

  # Move back
  mv "$tmpfile" "$file"
}

apply_sed frontend/src/Api/Api.elm "^module Api exposing" "module Api.Api exposing"
apply_sed frontend/src/Api/Data.elm "^module Data exposing" "module Api.Data exposing"
apply_sed frontend/src/Api/Time.elm "^module Time exposing" "module Api.Time exposing"
apply_sed frontend/src/Api/Request/Default.elm "^module Request.Default exposing" "module Api.Request.Default exposing"

echo "Elm module namespace fix complete."
