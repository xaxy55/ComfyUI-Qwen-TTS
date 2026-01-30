#!/bin/bash
# Convert M4A recordings to WAV format suitable for Qwen3-TTS voice cloning
# Requirements: 24kHz, mono, 16-bit PCM

INPUT_DIR="./Recordings"
OUTPUT_DIR="./Recordings_WAV"

mkdir -p "$OUTPUT_DIR"

echo "Converting M4A files to WAV (24kHz, mono, 16-bit)..."
echo ""

count=0
for f in "$INPUT_DIR"/*.m4a; do
    if [ -f "$f" ]; then
        filename=$(basename "$f" .m4a)
        output="$OUTPUT_DIR/${filename}.wav"

        echo "Converting: $filename.m4a"
        ffmpeg -i "$f" -ar 24000 -ac 1 -sample_fmt s16 -y "$output" 2>/dev/null

        if [ $? -eq 0 ]; then
            echo "  ✓ Saved: $output"
            ((count++))
        else
            echo "  ✗ Failed: $filename"
        fi
    fi
done

echo ""
echo "Done! Converted $count files to $OUTPUT_DIR"
echo ""
echo "You can now use these WAV files in ComfyUI with the VoiceClone node:"
echo "  1. Load a WAV file using 'Load Audio' node"
echo "  2. Connect to 'VoiceClone' node's ref_audio input"
echo "  3. Optionally add the transcript text in ref_text for better quality"
