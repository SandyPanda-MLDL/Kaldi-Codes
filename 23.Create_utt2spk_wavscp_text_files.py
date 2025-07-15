import os
import re
import json

# Paths
audio_dir = "/home/Sharedata/sandipan/Voice_Editing_VTLN/VTLN-Experiment/SNR_Experiment/MPS_All_Original_Dataset_Folder_Wise/5/PCM/538_2/"
json_path = "/home/Sharedata/sandipan/Voice_Editing_VTLN/VTLN-Experiment/data.json"
output_dir = audio_dir  # Or use another path

# Symbols to remove
symbols_to_remove = {"SIL", "BR", "ON", "FP", "IR", "MB", "WH"}

# Load transcript JSON
with open(json_path, "r") as jf:
    data = json.load(jf)

id_to_transcript = {}
for item in data:
    audio_id = item["audioID"]
    transcript = item.get("manualTranscript", "").strip()
    if transcript:
        id_to_transcript[audio_id] = transcript

# Output files
wavscp_path = os.path.join(output_dir, "wav.scp")
utt2spk_path = os.path.join(output_dir, "utt2spk")
text_path = os.path.join(output_dir, "text")

with open(wavscp_path, "w") as wavscp_file, \
     open(utt2spk_path, "w") as utt2spk_file, \
     open(text_path, "w") as text_file:

    for fname in os.listdir(audio_dir):
        if not fname.endswith(".wav"):
            continue

        utt_id = fname.replace(".wav", "")
        base_id = "_".join(utt_id.split("_")[:3])  # e.g., 3a2c_EN-OL-RC-234
        full_path = os.path.join(audio_dir, fname)

        # Write wav.scp and utt2spk
        wavscp_file.write(f"{utt_id} {full_path}\n")
        utt2spk_file.write(f"{utt_id} {utt_id}\n")  # Using utt_id as spk_id

        # Process transcript
        transcript = id_to_transcript.get(base_id, None)
        if transcript:
            filtered_tokens = [w for w in transcript.split() if w not in symbols_to_remove]
            cleaned_transcript = " ".join(filtered_tokens)
            text_file.write(f"{utt_id} {cleaned_transcript}\n")
        else:
            print(f"⚠️ No transcript found for {utt_id} (base_id: {base_id})")

print("✅ Files generated: wav.scp, utt2spk, text")
